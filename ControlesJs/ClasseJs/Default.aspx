<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.ClasseJs.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%--définition de la classe--%>
    <script src="ClasseOccupation.js"></script>

    <%--instanciation et utilisation de la classe--%>
    <script>
        $(function () {
            
            // exemple d'instanciation de la classe occupation
            var oc1 = new Occupation({
                id: 123,
                objet: "objet test",
                type: "type1",
                nature: "nat",
                debut: new Date()
            });    


            $("#btnStringifyClassObject").click(function() {
                $("#test1").html(JSON.stringify(oc1.data));
                return false;
            });
            
            
            $("#btnTestMethodePublique").click(function() {
                $("#test2").html(oc1.libelle);
                return false;
            });
        });
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">
    Dans cet exemple, on créé une instance de la <a href="ClasseOccupation.js">classe Occupation</a>.<br/>
    Le contenu de cette classe est sérialisé ci dessous, et la ligne suivante affiche le retour d'une de ses méthodes publiques.

    <hr />
    <button id="btnStringifyClassObject" class="btn btn-primary btn-xs btn-lg" >Visualisation objet de la classe</button>
    <p id="test1"></p>
    <br/>
    <button id="btnTestMethodePublique" class="btn btn-primary btn-xs btn-lg" >Appel d'une méthode publique de l'instance</button>
    <p id="test2"></p>

</asp:Content>
