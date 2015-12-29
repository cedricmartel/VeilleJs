
var testController = new function() {
    var that = this;

    // les données, initialisées avec les valeurs par défaut, et avec les commentaires associés
    that.data = {
        idBouton: null, // id du bouton qui va déclencher l'action de test
        idLibelle: null // id du libelle permettant de 
    };

    // fonction d'initialisastion du controller
    that.init = function (data) {
        // on ajoute dans that.data les données passées en paramètre
        that.data = $.extend(true, {}, that.data, data);

        // initialisation des événements 
        if (!!that.data.idBouton) {
            var bouton = $("#" + that.data.idBouton);
            bouton.click(function()
            {
                that.action();
                return false;
            });
        }
    };

    // evenement click sur le bouton
    that.action = function() {
        var lblResultat = $("#" + that.data.idLibelle);
        var now = new Date();
        lblResultat.append("<br/>" + now);
    };

};