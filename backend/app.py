from flask import Flask, request, jsonify
from sentence_transformers import SentenceTransformer, util
from duckduckgo_search import DDGS
import ollama
import pickle
import glob

app = Flask(__name__)
# Load embeddings (if created) for database
embeddings = pickle.load(open("embeddings.pkl", "rb")) if glob.glob("embeddings.pkl") else None
embedder = SentenceTransformer('all-MiniLM-L6-v2')

def search_database(query):
    db_file = "model/database.txt"  # Adjust the path if necessary
    
    if embeddings:
        query_emb = embedder.encode(query)
        scores = {f: util.cos_sim(query_emb, emb) for f, emb in embeddings.items()}
        top_file = max(scores, key=scores.get)
        if top_file == db_file:
            with open(top_file, encoding='utf-8') as f:
                return f.read()
        else:
            return "No relevant data found in database.txt with embeddings."
    else:
        try:
            with open(db_file, encoding='utf-8') as f:
                content = f.read()
            sections = [section.strip() for section in content.split('&&') if section.strip()]
            for section in sections:
                if query.lower() in section.lower():
                    return section
            return "No matching data found in database.txt."
        except FileNotFoundError:
            return "database.txt not found."
        except UnicodeDecodeError:
            return "Error decoding database.txt. Ensure it is saved as UTF-8."
        

def search_web(query, max_results=3):
    with DDGS() as ddgs:
        results = list(ddgs.text(query, max_results=max_results))
    web_content = "\n".join([f"{r['title']}: {r['body']}" for r in results])
    return web_content if web_content else "No web results found."

def detect_conflict(db_context, web_context, threshold=0.7):
    # If web context is empty or "No web results found", no conflict—favor database
    if not web_context or web_context == "No web results found.":
        return False
    
    # If database context is empty, favor web context (though ideally this shouldn't happen)
    if not db_context or db_context == "No matching data found in database.txt.":
        return False
    
    # Use sentence transformer to encode both contexts
    # if db_context.i
    db_embedding = embedder.encode(db_context)
    web_embedding = embedder.encode(web_context)
    
    # Compute cosine similarity
    similarity = util.cos_sim(db_embedding, web_embedding).item()
    
    # If similarity is below the threshold, consider it a conflict
    return similarity < threshold

def query_llama2(question, db_context, web_context):
    conflict = detect_conflict(db_context, web_context)
    
    if conflict:
        prompt = (
            f"The database and web data conflict. Use ONLY the database data to answer. "
            f"Database data: '{db_context}'. "
            f"Answer the question: {question}. Ensure the answer is complete and detailed."
        )
    else:
        prompt = (
            f"Based on the following database data: '{db_context}' and web data: '{web_context}', "
            f"answer the question: {question}. Ensure the answer is complete and detailed."
        )
    
    response = ollama.generate(model="gemma3:1b", prompt=prompt)
    return response["response"]

@app.route('/ask', methods=['POST'])
def ask():
    question = request.json.get('question')
    print(question)
    # reference_iit = ("IIT indore" in question) | ("IITI" in question)
    question = question + " with reference to IIT Indore"
    db_context = search_database(question)  # Database search
    web_context = search_web(question)  
    # if reference_iit:
    #     question = question + " with reference to IIT Indore"
    #     db_context = search_database(question)  # Search database for IIT Indore
    #     web_context = "No web search needed."  # Skip web search if IIT Indore is mentioned
    # else:
    #     db_context = search_database(question)  # Database search
    #     web_context = search_web(question)  # Web search in case it's not IIT Indore
    answer = query_llama2(question, db_context, web_context)
    print(answer)
    return jsonify({'answer': answer})

if __name__ == '__main__':
   app.run(debug=True, host='0.0.0.0', port=5000)


