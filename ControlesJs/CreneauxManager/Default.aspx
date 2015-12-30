<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.CreneauxManager.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script src="CreneauxSelector.js"></script>
    <link href="CreneauxSelector.css" rel="stylesheet" />

    <script>
        // click sur le bouton get selection
        function getSelection() {
            var o = JSON.stringify($("#creneauGarde").creneau("getSelection"));
            $("#selection").html(o);
        }

        // click sur le bouton set selection
        function setSelection() {
            $("#creneauGarde").creneau("setSelection", [
                [7.5, 8.5],
                [9, 9.5],
                [10, 11.5],
                [12, 12.5],
                [13, 14],
                [15, 15.5],
                [16, 16.5],
                [18, 19],
                [19.5, 20.5],
                [21, 21.5],
                [22, 22.5],
                [24, 25],
                [25.5, 26],
                [27, 29.5],
                [30, 30.5],
                [31, 31.5]
            ]);
        }

        // initialisation controle 
        var savedData = null;
        $(function () {
            $("#creneauGarde").creneau({
                heureDebut: 7.5,
                peutSaisirMinute: false,
                boutons: {
                    element: "button",
                    cssClass: "btn-xs btn-default"
                },
                events: {
                    onChange: function () { console.log("selected: " + JSON.stringify($("#creneauGarde").creneau("getSelection"))); },
                },
            });

            $("#btnSave").click(function () {
                savedData = $("#creneauGarde").creneau("getSelection");
                $("#saveInfo").html("sauvegardé: " + JSON.stringify(savedData));
                return false;
            });
            $("#btnLoad").click(function () {
                $("#creneauGarde").creneau("setSelection", savedData);
                $("#saveInfo").html("chargé: " + JSON.stringify(savedData));
                return false;
            });
            $("#btnSetFrames").click(function () {
                $("#creneauGarde").creneau("setFrames", eval($("#frames").val()));
                return false;
            });
            $("#btnSetExclusions").click(function () {
                $("#creneauGarde").creneau("setExclusions", eval($("#exclusions").val()));
                return false;
            });
            $("#btnNoFramesExclusions").click(function () {
                $("#creneauGarde").creneau("resetLimitations");
                return false;
            });
        });
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">
    <p>
        Ce controle permet de saisie des plages d'heures, à la demie heure, sur une journée<br/>
        Les créneaux sont modélisées par une liste de [début, fin], compté en nombre d'heures (7.5 = 7h30)
    </p>
    <hr />
    <div id="creneauGarde"></div>
    <hr />

    <p>
        <button id='btnSelection' onclick="getSelection(); return false;" class="btn-sm btn-primary">Afficher sélection</button>
        <label id='selection' />
    </p>
    <p>
        <button id='btnSetSelection' onclick="setSelection(); return false;" class="btn-sm btn-primary">Set sélection</button>
    </p>
    <p>
        <button id='btnSave' class="btn-sm btn-primary">Sauvegarder sélection</button>
        <button id='btnLoad' class="btn-sm btn-primary">Charger sélection</button>
        <label id="saveInfo"></label>
    </p>
    <p>
        <input type="text" id="frames" value="[[7.5, 19.5]]" />
        <button id="btnSetFrames" class="btn-sm btn-primary">Définition de la plage saisissable</button>
    </p>
    <p>
        <input type="text" id="exclusions" value="[[7.5, 9],[13.5,14.5]]" />
        <button id="btnSetExclusions" class="btn-sm btn-primary">Ajouter des exclusions</button>
    </p>
    <p>
        <button id="btnNoFramesExclusions" class="btn-sm btn-primary">Désactiver les limitations</button>
    </p>

</asp:Content>
