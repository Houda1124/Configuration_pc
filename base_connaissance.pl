%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Base de faits  - Configurateur PC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processeurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% processeur(ID, Socket, TDP)
processeur(proc_ryzen3_3100, am4, 65).
processeur(proc_ryzen5_3600, am4, 65).
processeur(proc_ryzen5_5600x, am4, 65).
processeur(proc_ryzen7_5800x, am4, 105).
processeur(proc_ryzen9_5900x, am4, 105).
processeur(proc_ryzen7_7700x, am5, 105).
processeur(proc_ryzen9_7950x, am5, 170).

processeur(proc_i3_12100f, lga1700, 60).
processeur(proc_i5_12400f, lga1700, 65).
processeur(proc_i5_13600k, lga1700, 125).
processeur(proc_i7_13700k, lga1700, 125).
processeur(proc_i9_13900k, lga1700, 125).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cartes mères
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% carte_mere(ID, Socket, TypeRAM, FreqMax, Format)
carte_mere(cm_a520m, am4, ddr4, 3200, matx).
carte_mere(cm_b450, am4, ddr4, 3466, atx).
carte_mere(cm_b550, am4, ddr4, 3600, atx).
carte_mere(cm_x570, am4, ddr4, 4400, atx).
carte_mere(cm_b650, am5, ddr5, 6000, atx).
carte_mere(cm_x670e, am5, ddr5, 6400, atx).

carte_mere(cm_h610, lga1700, ddr4, 3200, matx).
carte_mere(cm_b660, lga1700, ddr4, 3600, atx).
carte_mere(cm_z690, lga1700, ddr5, 5600, atx).
carte_mere(cm_z790, lga1700, ddr5, 7200, atx).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ram(ID, Type, Frequence, Taille)
ram(ram_ddr4_2666_8go, ddr4, 2666, 8).
ram(ram_ddr4_3200_8go, ddr4, 3200, 8).
ram(ram_ddr4_3200_16go, ddr4, 3200, 16).
ram(ram_ddr4_3600_16go, ddr4, 3600, 16).
ram(ram_ddr4_4000_32go, ddr4, 4000, 32).

ram(ram_ddr5_4800_8go, ddr5, 4800, 8).
ram(ram_ddr5_5200_16go, ddr5, 5200, 16).
ram(ram_ddr5_5600_32go, ddr5, 5600, 32).
ram(ram_ddr5_6400_32go, ddr5, 6400, 32).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cartes graphiques
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% carte_graphique(ID, TDP, Longueur)
carte_graphique(cg_gtx1650, 75, 180).
carte_graphique(cg_gtx1660, 120, 220).
carte_graphique(cg_rtx3050, 130, 200).
carte_graphique(cg_rtx3060, 170, 245).
carte_graphique(cg_rtx3070, 220, 267).
carte_graphique(cg_rtx3080, 320, 285).
carte_graphique(cg_rtx4070, 200, 250).
carte_graphique(cg_rtx4080, 320, 300).
carte_graphique(cg_rtx4090, 450, 336).
carte_graphique(cg_rx6600, 132, 210).
carte_graphique(cg_rx6700xt, 230, 267).
carte_graphique(cg_rx7800xt, 263, 280).
carte_graphique(cg_rx7900xt, 315, 287).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alimentations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alimentation(ID, Puissance)
alimentation(alim_400w, 400).
alimentation(alim_450w, 450).
alimentation(alim_500w, 500).
alimentation(alim_550w, 550).
alimentation(alim_600w, 600).
alimentation(alim_650w, 650).
alimentation(alim_700w, 700).
alimentation(alim_750w, 750).
alimentation(alim_850w, 850).
alimentation(alim_1000w, 1000).
alimentation(alim_1200w, 1200).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Règles de compatibilité
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compatibilité CPU / Carte mère
compatible_cpu_cm(CPU, CM) :-
    processeur(CPU, Socket, _),
    carte_mere(CM, Socket, _, _, _).

% Compatibilité Carte mère / RAM
compatible_cm_ram(CM, RAM) :-
    carte_mere(CM, _, TypeRAM, Fmax, _),
    ram(RAM, TypeRAM, Freq, _),
    Freq =< Fmax.

% Consommation totale CPU + GPU
consommation_totale(CPU, GPU, ConsoTotale) :-
    processeur(CPU, _, TDPcpu),
    carte_graphique(GPU, TDPgpu, _),
    ConsoTotale is TDPcpu + TDPgpu + 100. % marge pour le reste du système

% Vérifier si l’alimentation est suffisante
alim_suffisante(CPU, GPU, ALIM) :-
    consommation_totale(CPU, GPU, Conso),
    alimentation(ALIM, Puissance),
    Puissance >= Conso.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Règle de configuration valide
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

configuration_valide(CPU, CM, RAM, GPU, ALIM) :-
    compatible_cpu_cm(CPU, CM),
    compatible_cm_ram(CM, RAM),
    alim_suffisante(CPU, GPU, ALIM).
