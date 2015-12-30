<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.ClasseJs.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%--définition de la classe--%>
    <script src="ClasseOccupation.js"></script>

    <%--instanciation et utilisation de la classe--%>
    <script>
        $(function () {
            var oc1 = new Occupation({
                id: 123,
                guid: "test",
                objet: "objet test",
                type: "type1",
                nature: "nat",
                debut: new Date()
            });

            $("#test").html(JSON.stringify(oc1.data));
            $("#test2").html(oc1.libelle());
        });
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">
    Dans cet exemple, on créé une instance de la <a href="ClasseOccupation.js">classe Occupation</a>.<br/>
    Le contenu de cette classe est sérialisé ci dessous, et la ligne suivante affiche le retour d'une de ses méthodes publiques.

    <hr />

    <p id="test"></p>
    <p id="test2"></p>

</asp:Content>
