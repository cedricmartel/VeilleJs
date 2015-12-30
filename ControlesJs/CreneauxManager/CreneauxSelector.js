// gestionnaire de créneaux à la demie heure
// http://jsfiddle.net/cedricmartel/eEx9D/


$(function () {
    $.widget("custom.creneau", {
        options: null,

        // constructor
        _create: function () {
            var that = this;
            var defautOptions = {
                heureDebut: 7,
                exclusions: null, // [[7, 9], [19, 31]]
                peutSaisirMinute: false,
                boutons: {
                    position: "bas", // "haut" ou "bas"
                    element: "a", // "a" ou "button"
                    cssClass: "", 
                    selections: [{ h: [[0, 24]], lbl: "Tout" }, { h: [], lbl: "Aucun" }]
                },
                events: {
                    onDragStart: null,
                    onDragStop: null,
                    onChange: null,
                },
                frame: null
            };
            that.options = $.extend(true, {}, defautOptions, that.options);
            var options = that.options;

            var curTr = null, td, i, maxI;

            // sélection multiple / minute
            if (that.options.peutSaisirMinute) {
                $("<div style='width:100%; text-align:left;'><input type='radio' name='selType' value='mu' id='selTypeMu' checked='checked'><label for='selTypeMu'>Saisie multiple à la demie  heure</label>&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name='selType' value='mi' id='selTypeMi'><label for='selTypeMi'>Saisie à la minute</label></div>")
                    .appendTo(that.element);
                that._on($(that.element.find("input[type=radio]")), {
                    change: that._selMinuteCreneauChange
                });

                var selMin = $("<table class='selMinutes' style='display:none' />").appendTo(that.element);
                curTr = $("<tr/>").appendTo(selMin);
                $("<td>Début</td>").appendTo(curTr);
                $("<td><input class='timeDeb' type='text' style='width:50px' /></td>").appendTo(curTr);
                $("<td class='j1Deb' style='display:none'>J+1</td>").appendTo(curTr);
                $("<td>Fin</td>").appendTo(curTr);
                $("<td><input class='timeFin' type='text' style='width:50px' /></td>").appendTo(curTr);
                $("<td style='display:none' class='j1Fin'>J+1</td>").appendTo(curTr);
                that._on($(curTr.find("input")), {
                    change: that._formatSaisieMinute
                });
                curTr.find("input[type=text]").focus(function () {
                    that.select();
                });
                that._loadSaisieMinute(that.options.heureDebut, that.options.heureDebut);
            }

            // création du contenu
            var table = $("<table class='creneauTable' border='0' cellpadding='0' cellspacing='1'/>").appendTo(that.element);
            curTr = null;
            for (i = options.heureDebut, maxI = options.heureDebut + 24; i < maxI; i += 0.5) {
                if ((i - options.heureDebut) % 6 == 0) {
                    curTr = $("<tr/>").appendTo(table);
                }
                var nbMin = that._nombreMinutes(i);
                var nbH = Math.floor(i);
                if (nbH >= 24) nbH -= 24;
                $("<td class='creneauSelector' val='" + i + "'>" + nbH + "h" + (nbMin > 0 ? nbMin : "") + "</td>").appendTo(curTr);
            }

            // evenements sur les cellules
            td = that.element.find(".creneauSelector");
            td.attr('unselectable', 'on');
            that._on(td, {
                mouseenter: that._creneauMouseEnter,
                mousedown: that._creneauMouseDown,
                mouseup: that._creneauMouseUp,
            });
            that._on(that.element, {
                mouseleave: that._creneauMouseLeave
            });

            // liens tous / aucun
            var linkTag = options.boutons.element;
            if (options.boutons.selections != null) {
                for (i = options.boutons.selections.length - 1; i >= 0; i--) {
                    var dataLink = options.boutons.selections[i];
                    var link = $("<" + linkTag + " style='cursor:pointer' class='" + options.boutons.cssClass + "' >" + dataLink.lbl + "</" + linkTag + ">");
                    if (linkTag == "button")
                        link.button();
                    if (options.boutons.position == "haut")
                        link = link.prependTo(that.element);
                    else {
                        link = link.appendTo(that.element);
                        $("<span>&nbsp;&nbsp;</span>").appendTo(that.element);
                    }
                    var fctClickLien = function (elements) {
                        return function () {
                            // on ajoute l'heure de début de centre car les heures des boutons commencent à cette heure (entre 0 et 24)
                            var hDeb = that.options.heureDebut, params = [];
                            for (var j = 0; j < elements.length; j++)
                                params.push([elements[j][0] + hDeb, elements[j][1] + hDeb]);
                            that.setSelection(params);
                            that._selChange();
                            return false;
                        };
                    };
                    that._on(link, {
                        click: fctClickLien(dataLink.h)
                    });
                }
            }

            // frame
            that.setFrames(options.frame);
        },

        // plages selectionnées
        _cacheSelection: null,
        getSelection: function (forceVideCache) {
            var that = this;
            if (that._cacheSelection != null && !forceVideCache)
                return this._cacheSelection;

            var res = Array(),
                deb = null;
            if (that._modeSaisieCreneau() == "mi") {
                that._formatSaisieMinute();
                var hDeb = that._parseTime(that.element.find(".timeDeb").val(), false);
                var hFin = that._parseTime(that.element.find(".timeFin").val(), true);
                if (hDeb != null && hFin != null && hDeb != hFin) res[0] = [hDeb, hFin];
            } else {
                var td = that.element.find("td.creneauSelector:not(.creneauUnselectable)");
                for (var i = that.options.heureDebut, maxI = that.options.heureDebut + 24; i < maxI; i += 0.5) {
                    var checked = td.filter("[val=" + (i + "").replace(".", "\\.") + "]").hasClass("creneauSelected");
                    if (checked && deb == null) deb = i;
                    if (!checked && deb != null) {
                        res[res.length] = [deb, i];
                        deb = null;
                    }
                }
                if (deb != null) res[res.length] = [deb, that.options.heureDebut + 24];
            }
            that._cacheSelection = res;
            return res;
        },

        setSelection: function (liste) {
            var that = this;
            that._clearSelection();
            that._cacheSelection = liste;
            if (liste != null && liste.length > 0) {
                if (that.options.peutSaisirMinute && liste.length == 1 && ((2 * liste[0][0]) % 1 > 0 || (2 * liste[0][1]) % 1 > 0)) {
                    that.element.find("input[name=selType]").filter('[value=mi]').prop('checked', true);
                    that._loadSaisieMinute(liste[0][0], liste[0][1]);
                } else {
                    that.element.find("input[name=selType]").filter('[value=mu]').prop('checked', true);
                    for (var i = 0, maxI = liste.length; i < maxI; i++) {
                        var l = liste[i];
                        if (l == null || l.length != 2) continue;
                        that._creneauColorFromTo(l[0], l[1], that._selClass, false);
                    }
                }
            }
            that._selMinuteCreneauChange();
        },

        // empecher la saisie en dehors des creneaux
        setFrames: function (creneaux) {
            this.options.frames = creneaux;
            this.majDisplay();
        },

        setExclusions: function (creneaux) {
            this.options.exclusions = creneaux;
            this.majDisplay();
        },

        resetLimitations: function () {
            this.options.frames = null;
            this.options.exclusions = null;
            this.majDisplay();
        },

        addExclusions: function (creneaux) {
            if (this.options.exclusions == null) this.options.exclusions = [];
            this.options.exclusions = this.options.exclusions.concat(creneaux);
            this.majDisplay();
        },

        majDisplay: function () {
            var frames = this.options.frames, exclusions = this.options.exclusions;
            var td = this.element.find("td.creneauSelector");
            td.removeClass("creneauUnselectable");

            function heureDansCreneaux(creneaux, heure, defaut) {
                if (creneaux == null)
                    return defaut;
                for (var j = 0; j < creneaux.length; j++) {
                    var creneau = creneaux[j];
                    if (i >= creneau[0] && i < creneau[1])
                        return true;
                }
                return false;
            }

            for (var i = this.options.heureDebut, maxI = this.options.heureDebut + 24; i < maxI; i += 0.5) {
                var frame = heureDansCreneaux(frames, i, true);
                var exclusion = heureDansCreneaux(exclusions, i, false);
                if (!frame || exclusion)
                    td.filter("[val=" + (i + "").replace(".", "\\.") + "]").addClass("creneauUnselectable");
            }
        },

        // privates 
        _nombreMinutes: function (decimalHeures) {
            return (decimalHeures * 100 % 100) * 0.6;
        },

        _selClass: "creneauSelected",
        _tempSelClass: "creneauSelectedTemp",
        _flagCreneauMouse: false,
        _debCreneau: null,

        _creneauMouseDown: function (e) {
            var that = this;
            that._flagCreneauMouse = true;
            that._debCreneau = parseFloat($(e.target).attr("val"));
            $("." + that._tempSelClass).removeClass(that._tempSelClass);
            this._creneauColorFromTo(this._debCreneau, that._debCreneau, that._tempSelClass, true);
            if (that.options.events.onDragStart != null)
                this.options.events.onDragStart();
        },

        _creneauMouseUp: function (e) {
            var that = this;
            that._flagCreneauMouse = false;
            $("." + that._tempSelClass).removeClass(that._tempSelClass);
            that._creneauColorFromTo(that._debCreneau, parseFloat($(e.target).attr("val")), that._selClass, true);
            if (that.options.events.onDragStop != null)
                that.options.events.onDragStop();
            that._selChange();
        },

        _creneauMouseEnter: function (e) {
            var that = this;
            if (that._flagCreneauMouse) {
                $("." + that._tempSelClass).removeClass(that._tempSelClass);
                that._creneauColorFromTo(that._debCreneau, parseFloat($(e.target).attr("val")), that._tempSelClass, true);
            }
        },

        _creneauMouseLeave: function () {
            var that = this;
            if (that._flagCreneauMouse) {
                $("." + this._tempSelClass).addClass(that._selClass).removeClass(that._tempSelClass);
                that._flagCreneauMouse = false;
                if (that.options.events.onDragStop != null)
                    that.options.events.onDragStop();
                that._selChange();
            }
        },

        _clearSelection: function () {
            var that = this;
            that._cacheSelection = null;
            that.element.find(".creneauSelected").removeClass("creneauSelected");
            that.element.find("input[type=text]").val("");
            that._formatSaisieMinute();
            that._selChange();
            return false;
        },

        _selChange: function () {
            this._cacheSelection = null;
            if (typeof (this.options.events.onChange) == "function")
                this.options.events.onChange();
        },

        _creneauToggle: function (n, currentClass) {
            var c = this.element.find("td[val=" + (n + "").replace(".", "\\.") + "]");
            if (currentClass == this._selClass) {
                if (c.hasClass(this._selClass)) c.removeClass(currentClass);
                else c.addClass(currentClass);
            } else c[0].className = currentClass + " " + c[0].className;
        },

        _creneauColorFromTo: function (f, t, currentClass, inclFin) {
            var deb = f < t ? f : t,
                fin = f < t ? t : f;
            for (var i = Math.round(deb * 2) / 2.; inclFin ? i <= fin : i < fin; i += 0.5)
                this._creneauToggle(i, currentClass);
        },

        _setOptions: function () {
            this._superApply(arguments);
        },

        _modeSaisieCreneau: function () {
            // mu = multiple, ou mi = minute
            return this.element.find("input[name=selType]:checked").val();
        },

        _selMinuteCreneauChange: function () {
            var that = this;
            var selEl = that._modeSaisieCreneau();
            if (selEl === "mu") {
                that.element.find(".creneauTable").show();
                that.element.find(".selMinutes").hide();
            } else if (selEl === "mi") {
                that.element.find(".creneauTable").hide();
                that.element.find(".selMinutes").show();
                if (that.element.find(".timeDeb").val() == "" || that.element.find(".timeFin").val() == "") that._loadSaisieMinute(that.options.heureDebut, that.options.heureDebut + 24);
            }
        },

        _loadSaisieMinute: function (deb, fin) {
            if (deb >= 24) deb = deb - 24;
            if (fin >= 24) fin = fin - 24;
            var minDeb = Math.round((deb * 10000 % 10000) * 0.006);
            var minFin = Math.round((fin * 10000 % 10000) * 0.006);
            var hDeb = Math.floor(deb);
            var hFin = Math.floor(fin);
            this.element.find(".timeDeb").val(hDeb + ":" + (minDeb < 10 ? "0" : "") + minDeb);
            this.element.find(".timeFin").val(hFin + ":" + (minFin < 10 ? "0" : "") + minFin);
            this._formatSaisieMinute();
        },

        _formatSaisieMinute: function () {
            var that = this;
            var fastFill = function (el) {
                if (el == null || el.length == 0)
                    return;
                var txt = el.val();
                if (txt.indexOf(":") < 0 && txt.length > 2 && txt.length <= 4)
                    el.val(txt.replace(new RegExp("^([0-9]{1,2})([0-9]{2})$", "g"), "$1:$2"));
            };
            fastFill(that.element.find(".timeDeb"));
            fastFill(that.element.find(".timeFin"));

            var hDeb = that._parseTime(that.element.find(".timeDeb").val(), false);
            var hFin = that._parseTime(that.element.find(".timeFin").val(), true);
            if (hDeb == null)
                that.element.find(".timeDeb").val("");
            if (hFin == null)
                that.element.find(".timeFin").val("");
            if (hFin < hDeb) {
                that.element.find(".timeFin").val(that.element.find(".timeDeb").val());
                hFin = hDeb == that.options.heureDebut ? hDeb + 24 : hDeb;
            }
            that._formatSaisieMinuteJ1(hDeb, ".j1Deb");
            that._formatSaisieMinuteJ1(hFin, ".j1Fin");
        },

        _formatSaisieMinuteJ1: function (nbH, j1El) {
            if (nbH >= 24) $(j1El).show();
            else $(j1El).hide();
        },

        _parseTime: function (strTime, estFin) {
            // nb d'heures: 13:30 retourne 13,5; 3 retourne 24 + 3 si heuredeb < 3
            if (strTime == null) return null;
            var time = strTime.match(/(\d+)(?::(\d\d))?\s*(p?)/i);
            if (!time) {
                return null;
            }
            var hours = parseInt(time[1], 10);
            var minutes = parseInt(time[2], 10) || 0;
            var ret = hours + minutes / 60;
            if (ret < this.options.heureDebut || (ret == this.options.heureDebut && estFin)) ret = ret + 24;
            return ret;
        },

    });

});