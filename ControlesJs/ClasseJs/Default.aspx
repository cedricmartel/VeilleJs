<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.ControlesJs.ClasseJs.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%--définition de la classe--%>
    <script src="ClasseOccupation.js"></script>
    
    <%--instanciation et utilisation de la classe--%>
    <script>
        $(function() {
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
    
    <div id="test"></div>
    <br/>
    <br/>
    <div id="test2"></div>

</asp:Content>