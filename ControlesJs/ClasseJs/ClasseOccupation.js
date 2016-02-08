// exemlple utilisation d'une classe javascript avec constructeur 
function Occupation(p) {
    var that = this;

    /////////////////////////////////////////////////////
    // déclaration des membres avec les valeurs par défaut 
    that.data = {
        id: -1,
        objet: null,
        type: null,
        debut: null,
        fin: null,
    };

    ////////////////////////////////////////////////////
    // logique du constructeur
    if (p != null) {
        // on initialise la classe en prenant en compte les valeurs par défaut ci dessus 
        that.data = $.extend(true, {}, that.data, p);
    }

    ////////////////////////////////////////////////////
    // fonctions private 
    
    // convertit une date dans un format heure minute affichable 
    function heureToString(dte) {
        if (!(dte instanceof Date))
            return "null";
        return dte + ""; // serialisation js par defaut
    }

    ////////////////////////////////////////////////////
    // fonctions public
    that.debutHeureMinutes = function () {
        if (that.data.debut == null)
            return "NULL";
        return heureToString(that.data.debut);
    };
    that.finHeureMinutes = function () {
        if (that.data.fin == null)
            return "NULL";
        return heureToString(that.data.fin);
    };
    that.libelle = function () {
        return that.data.objet + '<br/>type: ' + that.data.type + '<br/>début: ' + that.debutHeureMinutes() + '<br/>fin: ' + that.finHeureMinutes();
    };

}