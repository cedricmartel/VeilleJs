<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="fr.cedricmartel.VeilleJs.CrossFilter.Default" MasterPageFile="~/Master.Master" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script src="crossfilter.js"></script>
    <script src="PositionsService.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    <script>

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

        /// search basée sur le crossFilter
        function searchCF(idPersonnel) {
            return crossFilterElements.dimensionP.filter(idPersonnel).top(Infinity);
        }

        /// TODO verifier que c'est bon
        // http://stackoverflow.com/questions/10608171/using-crossfilter-to-dynamically-return-results-in-javascript/10660123#10660123

        function searchMultiCF(idPersonnel, dTime) {
            crossFilterElements.dimensionD.filter(dTime);
            return crossFilterElements.dimensionP.filter(idPersonnel).top(Infinity);
        }

        /// search JS native
        function searchJs(idPersonnel) {
            var resultat = PositionsService.filter(function (e) { return e.p === idPersonnel; });
            return resultat;
        }

        function searchMultiJS(idPersonnel, dTime) {
            var result = [];
            for (var i = 0; i < PositionsService.length; i++) {
                if (PositionsService[i].p === idPersonnel && PositionsService[i].dTime === dTime) {
                    result.push(PositionsService[i]);
                }
            }
            return result;
        }

        function multisearch(fctsearch) {
            var startTime = +new Date();
            var nbEl = 0;
            for (var i = 0; i < paramsSearch.idPersonnels.length; i++) {
                nbEl += fctsearch(paramsSearch.idPersonnels[i]).length;
            }
            var elapsedTime = +new Date() - startTime;
            outputDiv.append(fctsearch.name + "Execution time: " + elapsedTime + " ms (" + nbEl + " items)<br/>");
            return elapsedTime;
        }

        function multisearchIdDate(fctsearch) {
            var startTime = +new Date();
            var nbEl = 0;
            for (var id = 0; id < paramsSearch.idPersonnels.length; id++) {
                for (var j = 0; j < paramsSearch.datesInit.length; j++) {
                    nbEl += fctsearch(paramsSearch.idPersonnels[id], paramsSearch.datesInit[j]).length;
                }
            }
            var elapsedTime = +new Date() - startTime;
            outputDiv.append(fctsearch.name + " execution time: " + elapsedTime + " ms (" + nbEl + " items)<br/>");
            return elapsedTime;
        }

        ///Initialisation du crossFilter
        function initCrossFilter() {
            crossFilterElements.list = crossfilter(PositionsService);
            crossFilterElements.dimensionP = crossFilterElements.list.dimension(function (x) { return x.p; });
            crossFilterElements.dimensionD = crossFilterElements.list.dimension(function (x) { return x.dTime; });
        }

        $(function () {

            outputDiv = $("#resultat");

            $("#btnsearch").click(function () {
                var dTime = +new Date;
                initCrossFilter();
                var timeCfInit1 = +new Date - dTime;

                outputDiv.append("crossfilter init time: " + timeCfInit1 + "ms<br/>");
                outputDiv.append("search 1 filter:<br/>");
                var tempsJs = multisearch(searchJs);
                var tempsCf = multisearch(searchCF);

                outputDiv.append("search 2 filters:<br/>");
                var tempsJsIdDate = multisearchIdDate(searchMultiJS);
                var tempsCfIdDate = multisearchIdDate(searchMultiCF);

                outputDiv.append("update data<br/>");
                // increment date field, result length must decrease
                for (var idx = 0; idx < PositionsService.length; idx++) {
                    var ps = PositionsService[idx];
                    ps.d.setDate(ps.d.getDate() + 1);
                    ps.dTime = ps.d.getTime();
                }

                dTime = +new Date;
                initCrossFilter();
                var timeCfInit2 = +new Date - dTime;

                outputDiv.append("crossfilter init time: " + timeCfInit2 + "ms<br/>");
                outputDiv.append("search 2 filters:<br/>");
                var tempsJsIdDateModif = multisearchIdDate(searchMultiJS);
                var tempsCfIdDateModif = multisearchIdDate(searchMultiCF);

                // stats
                var totalJs = tempsJs + tempsJsIdDate + tempsJsIdDateModif;
                var totalCf = tempsCf + tempsCfIdDate + tempsCfIdDateModif + timeCfInit1 + timeCfInit2;
                var diff = totalCf - totalJs;
                var pctDiff = parseInt(totalJs / totalCf * 100);

                outputDiv.append("Time diff " + diff + "ms = " + pctDiff + "% (js " + totalJs + "ms / crossfilter " + totalCf + "ms)");
                outputDiv.append("<hr style='height: 1px; width: 90%;' />");
                return false;
            });

            //chargement dates dates init
            for (var z = 0; z < PositionsService.length; z++) {
                PositionsService[z].d = new Date(PositionsService[z].d);
                var dateInit = PositionsService[z].d;
                if (paramsSearch.datesInit.length < 50 && $.inArray(dateInit, paramsSearch.datesInit) < 0)
                    paramsSearch.datesInit.push(dateInit.getTime());
            }

            // chargemnt des idPersonnels
            for (var i = 0; i < PositionsService.length; i++) {
                var p = PositionsService[i].p;
                if (paramsSearch.idPersonnels.length < 500 && $.inArray(p, paramsSearch.idPersonnels) < 0)
                    paramsSearch.idPersonnels.push(p);
            }

        });
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="PageContent" runat="server">
    <p>
        This page compares search times using <a href="https://github.com/square/crossfilter">cross filter lib</a> and traditional js .filter method
    </p>

    <button class="btn btn-primary btn-xs" id="btnsearch">Start test</button>
    <p>
        <div id="resultat"></div>
    </p>
</asp:Content>
