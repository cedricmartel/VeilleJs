
var testController = new function() {
    var that = this;

    // les données, initialisées avec les valeurs par défaut, et avec les commentaires associés
    that.data = {
        idBouton: null, // id du bouton qui va déclencher l'action de test
        idLibelle: null // id du libelle ou sera affiché les logs de l'action
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
                action();
                return false;
            });
        }
    };

    // evenement click sur le bouton
    function action() {
        var lblResultat = $("#" + that.data.idLibelle);
        var now = new Date();
        // on affiche juste la date pour cet exemples
        lblResultat.append("<br/>" + now);
    };

};