<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.BatchManager.Default" MasterPageFile="../Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <link href="BatchManager.css" rel="stylesheet" />
    <script src="BatchManager.js"></script>

    <script>

        $(function () {
            $("#batch1").batch({
                texts: {
                    addToBatch: "Ajouter au batch",
                },
                events: {
                    run: runBatch,
                    formToString: formToString1,
                },
                view: {
                    rowDeleteItem: "<a>Supprimer cet élément</a>",
                }
            });
            $("#batch2").batch({
                events: {
                    run: runBatch,
                    formToString: formToString2,
                }
            });
        });
        
        // fonctions pour les tests 
        function runBatch(i) {
            // methode de traitement des batch : juste un print pour cet exemple
            alert("run --> " + JSON.stringify(i));
        }
        function formToString1(formVal) {
            // fonction de mise en forme textuelle des données du formulaire 1
            return "texte=" + formVal.texte + " option=" + formVal.listeDeroulante + " radio=" + formVal.radio;
        }
        function formToString2(formVal) {
            // fonction de mise en forme textuelle des données du formulaire 2
            return "cb=" + formVal.myCb + " txt=" + formVal.myTxt;
        }

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">
    <p>
        Le controle BatchManager permet, pour un formulaire donné, de regrouper plusieurs saisies avant d'en effectuer un traitement (ex: envoi serveur)<br/>
        Dans cet exemple, ce controle est instancié sur chacune des 2 zones de formulaires suivantes 
    </p>
    <hr />
    <div id="batch1" class="well">
        <input type='text' value='val' id="texte" />
        <br />
        <select id="listeDeroulante">
            <option value='1'>option 1</option>
            <option value='2'>option 2</option>
            <option value='3'>option 3</option>
        </select>
        <br />
        <input type="radio" name="radio" value="radio1" id="radio1" />
        <label for="radio1">Radio 1</label>
        <br />
        <input type="radio" name="radio" value="radio2" id="radio2" checked="checked" />
        <label for="radio2">Radio 2</label>

        <br />
    </div>

    <div id="batch2" class="well">
        <input type="checkbox" id="myCb" value="chk" />
        <input type="text" id="myTxt" value="" />
    </div>

</asp:Content>
