from flask import Flask, render_template, request
from pyswip import Prolog

app = Flask(__name__)
prolog = Prolog()

# 🔁 Recharger le fichier Prolog correctement
try:
    list(prolog.query("unload_file('base_connaissance.pl')"))
except:
    pass

prolog.consult("base_connaissance.pl")

@app.route("/")
def index():
    cpus = [row["CPU"] for row in prolog.query("processeur(CPU, _, _)")]
    cms = [row["CM"] for row in prolog.query("carte_mere(CM, _, _, _, _)")]
    rams = [row["RAM"] for row in prolog.query("ram(RAM, _, _, _)")]
    gpus = [row["GPU"] for row in prolog.query("carte_graphique(GPU, _, _)")]
    alims = [row["ALIM"] for row in prolog.query("alimentation(ALIM, _)")]

    return render_template("index.html", cpus=cpus, cms=cms, rams=rams, gpus=gpus, alims=alims)

@app.route("/verifier", methods=["POST"])
def verifier():
    cpu = request.form.get("cpu")
    cm = request.form.get("cm")
    ram = request.form.get("ram")
    gpu = request.form.get("gpu")
    alim = request.form.get("alim")

    requete = f"configuration_valide({cpu}, {cm}, {ram}, {gpu}, {alim})"
    resultats = list(prolog.query(requete))

    if resultats:
        message = "✅ Configuration compatible !"
    else:
        message = "❌ Incompatibilité détectée."

    return render_template("resultat.html", message=message, cpu=cpu, cm=cm, ram=ram, gpu=gpu, alim=alim)

if __name__ == "__main__":
    app.run(debug=False)

