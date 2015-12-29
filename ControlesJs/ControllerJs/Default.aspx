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
                idLibelle: "resultat"
                // on peut aussi passer des textes ou des données...
            });
        });
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">

    <div class="">
        <asp:Button runat="server" ID="TestBtn" Text="test" CssClass="btn btn-primary btn-sm btn-lg" />
    </div>
    <label id="resultat"></label>

</asp:Content>
