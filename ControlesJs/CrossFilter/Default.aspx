<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.CrossFilter.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script src="crossfilter.js"></script>
    <script src="PositionsService.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    <script src="moment.js"></script>
    <script>
        //TODO Créer un INPUT pour ajouter un élément dans la liste.

        /// création d'un objet crossFilterElements 
        var crossFilterElements = {
            list: null,
            dimensionP: null,
            dimensionsD: null
        };

        var paramsSearch = {
            datesInit: [],
            idPersonnels: []
        };

        var outputDiv = null;
        
        
        
        /// Recherche basé sur le crossFilter
        function rechercheCF(idPersonnel) {
            return crossFilterElements.dimensionP.filter(idPersonnel).top(Infinity);
        }

        /// TODO verifier que c'est bon
        // http://stackoverflow.com/questions/10608171/using-crossfilter-to-dynamically-return-results-in-javascript/10660123#10660123
        
        function rechercheMultiCF(idPersonnel, date) {
            crossFilterElements.dimensionD.filter(date.getTime());
            return crossFilterElements.dimensionP.filter(idPersonnel).top(Infinity);
        }

        /// Recherche JS native
        function rechercheJs(idPersonnel) {
            var resultat = PositionsService.filter(function (e) { return e.p === parseInt(idPersonnel); });
            return resultat;
        }

        function rechercheMultiJS(idPersonnel, date) {
            var result = [];
            for (var i = 0; i < PositionsService.length; i++) {
                if (PositionsService[i].p === parseInt(idPersonnel) && PositionsService[i].d.getTime() == date.getTime()) {
                    result.push(PositionsService[i]);
                }
            }
            return result;
        }

        function multiRecherche(fctRecherche) {
            var startTime = moment.now();
            var nbEl = 0;
            for (var i = 0; i < paramsSearch.idPersonnels.length; i++) {
                nbEl += fctRecherche(paramsSearch.idPersonnels[i]).length;
            }
            var elapsedTime = new Date().getTime() - startTime;
            outputDiv.append("multiRecherche " + fctRecherche.name + "Execution time: " + elapsedTime + " ms (" + nbEl + " items)<br/>");
            return elapsedTime;
        }

        function multiRechercheIdDate(fctRecherche) {
            var startTime = new Date().getTime();
            var nbEl = 0;
            for (var id = 0; id < paramsSearch.idPersonnels.length; id++) {
                for (var j = 0; j < paramsSearch.datesInit.length; j++) {
                    nbEl += fctRecherche(paramsSearch.idPersonnels[id], paramsSearch.datesInit[j]).length;
                }
            }
            var elapsedTime = (moment.now() - startTime);
            outputDiv.append("multiRechercheIdDate " + fctRecherche.name + " execution time: " + elapsedTime + " ms (" + nbEl + " items)<br/>");
            return elapsedTime;
        }

        ///Initialisation du crossFilter
        function initCrossFilter() {
            crossFilterElements.list = crossfilter(PositionsService);
            crossFilterElements.dimensionP = crossFilterElements.list.dimension(function (d) { return d.p; });
            crossFilterElements.dimensionD = crossFilterElements.list.dimension(function (f) { return f.d; });
        }

        $(function () {

            outputDiv = $("#resultat");

            $("#btnSequentiel").click(function () {
                initCrossFilter();
                
                outputDiv.append("<hr style='height: 1px; width: 90%;' />");

               var tempsJs = multiRecherche(rechercheJs);
               var tempsCF =  multiRecherche(rechercheCF);
                outputDiv.append("<hr style='height: 1px; width: 90%;' />");
                
               var tempsJsIdDate = multiRechercheIdDate(rechercheMultiJS);
               var tempsCFIdDate = multiRechercheIdDate(rechercheMultiCF);
                outputDiv.append("<hr style='height: 1px; width: 90%;' />");

                for (var idx = 0; idx < PositionsService.length; idx++) {
                    var ps = PositionsService[idx];
                    ps.d.setDate(ps.d.getDate() + 1);               
                }
                var tempsJsIdDateModif = multiRechercheIdDate(rechercheMultiJS);
                var tempsCFIdDateModif = multiRechercheIdDate(rechercheMultiCF);

                outputDiv.append("<hr style='height: 1px; width: 90%;' />");
                // total js = N ms - totla cf = M ms
                var totalJs = tempsJs + tempsJsIdDate + tempsJsIdDateModif;
                var totalCF = tempsCF + tempsCFIdDate + tempsCFIdDateModif;
                var diff = totalJs - totalCF;
                outputDiv.append("La différence de temps est de: " + " " + diff + " " + "(" + "total js =" + totalJs + "ms" + " " + "-" + " " + "total cf =" + totalCF + "ms" + ")");
                
                return false;
            });
            

            //chargement dates dates init
            for (var z = 0; z < PositionsService.length; z++) {
                PositionsService[z].d = new Date(PositionsService[z].d);
                var dateInit = PositionsService[z].d;
                if (paramsSearch.datesInit.length < 50 && $.inArray(dateInit, paramsSearch.datesInit) < 0)
                    paramsSearch.datesInit.push(new Date(dateInit.getTime()));
            }


            // chargemnt des idPersonnels
            for (var i = 0; i < PositionsService.length; i++) {
                var p = PositionsService[i].p;
                if (paramsSearch.idPersonnels.length < 500 && $.inArray(p, paramsSearch.idPersonnels) < 0)
                    paramsSearch.idPersonnels.push(p);
            }

            // initialisation dimensions crossFilter
            initCrossFilter();

        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">

    <p>
        Ce controle permet de recherher une position à partir d'une liste de positions de services<br />
        L'objectifs étant de pouvoir évaluer le temps de recherche !!!
    </p>

    <hr />

    <div id="MultiRechercheIdDate">
        <table style="width: 100%">
            <tr>
                <td colspan="2" style="text-align: center">
                    <hr />
                    <p>
                        <button class="btn btn-primary" id="btnSequentiel">Rechercher</button>
                    </p>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <div id="resultat"></div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
