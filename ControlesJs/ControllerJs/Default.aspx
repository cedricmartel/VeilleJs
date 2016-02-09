<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.ControllerJs.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%--Ce fichier contient la définition du controller--%>
    <script src="TestController.js"></script>
    <%--dautres fichiers peuvent étendre ce controller, il s'agit en quelque sorte d'un controller dans un controller--%>
    <%--    TODO <script src="TestController.async.js"></script>--%>

    <script>
        // initialisation du controller 
        // c'est ici que l'on passera les variables issues du code behind 
        $(function () {
            testController.init({
                // ici les valeur d'initialisation
                idBouton: "<%=TestBtn.ClientID%>", // ex pour passer l'id d'un controle serveur
                idLibelle: "resultat",
                donnees: [1, 2, 5, 7, 9],
                bouttonId: "<%=BtnTest.ClientID%>"
                // on peut aussi passer des textes ou des données...
        });
        });
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">
    Cette page présente un exemple d'utilisation de controlleur d'ihm client.<br/>
    C'est assez simple ici, lors du chargement de la page, la methode init du controller est appellée, en passant en paramètres de la page (ex: données, id de controles server, ...). <br/>
    Ici, cette methode ini va ajouter un déclencheur sur le bouton, mappant sur une méthode privée du controller. 
    <hr />
    <p>
        <asp:Button runat="server" ID="TestBtn" Text="test" CssClass="btn btn-primary btn-sm btn-lg" />
        <asp:Button runat="server" ID="BtnTest" Text="valide" CssClass="btn btn-success btn-sm btn-lg" />
    </p>
    <label id="resultat"></label>

</asp:Content>
