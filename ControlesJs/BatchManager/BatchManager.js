// batch manager adaptable à n'importe quel formulaire
// http://jsfiddle.net/cedricmartel/M6J2N/

$(function () {
    $.widget("custom.batch", {
        options: null,

        // constructor
        _create: function () {
            var defautOptions = {
                events: {
                    run: null,
                    formToString: null,
                    canAddBatch: null,
                },
                texts: {
                    addToBatch: "Ajouter",
                    launchBatch: "Traiter",
                    emptyBatch: "Vider",
                },
                view: {
                    rowDeleteItem: "<a>del</a>",
                }
            };
            this.options = $.extend(true, {}, defautOptions, this.options);

            // bouton ajouter au batch
            var btnAdd = $("<button class='batchBtn'>" + this.options.texts.addToBatch + "</button>").appendTo(this.element);
            this._on(btnAdd, {
                click: "_addToBatchList"
            });

            // table liste bacth
            $("<br/>").appendTo(this.element);
            this.batchTable = $("<table cellpadding=2 cellspacing=0 class='batchListTbl' />").appendTo(this.element);

            // init instance variables
            this.batchItems = [];
        },

        _formVals: function () {
            var ret = {};
            $(this.element).find(':input').each(function () {
                var i = $(this);
                var id = i.attr("id");
                var val = i.val();
                if (i.attr("type") == "checkbox")
                    val = i.prop("checked") ? i.val() : null;
                if (i.attr("type") == "radio")
                    id = i.prop("checked") ? i.attr("name") : undefined;
                if (id != undefined)
                    ret[id] = val;
            });
            return ret;
        },

        _addToBatchList: function () {
            if (this.options.events.canAddBatch != null && !this.options.events.canAddBatch())
                return false;

            var vals = this._formVals();
            this.batchItems[this.batchItems.length] = vals;
            var tr, td;
            tr = $("<tr/>").appendTo(this.batchTable);
            td = $("<td class='batchListRow'/>").appendTo(tr);
            td.html(this.options.events.formToString(vals));
            td = $("<td class='batchListRow' align='right'/>").appendTo(tr);
            var delBtn = $(this.options.view.rowDeleteItem).appendTo(td);
            this._on(delBtn, { click: "_delItem" });

            if (this.batchItems.length == 1) {
                this.btnRun = $("<button class='batchBtn'>" + this.options.texts.launchBatch + "</button>").appendTo(this.element);
                this._on(this.btnRun, { click: "_runBatch" });
                this.btnEmpty = $("<button class='batchBtn'>" + this.options.texts.emptyBatch + "</button>").appendTo(this.element);
                this._on(this.btnEmpty, { click: "emptyBatch" });
            }
            return false;
        },

        _runBatch: function () {
            this.options.events.run(this.batchItems);
            return false;
        },

        _delItem: function (e) {
            var idxEl = $(e.target.parentNode.parentNode).index();
            this.batchItems.splice(idxEl, 1);
            this.batchTable[0].deleteRow(idxEl);
            if (this.batchItems.length == 0) {
                this.emptyBatch();
            }
            return false;
        },

        emptyBatch: function () {
            this.batchItems = [];
            this.batchTable.html("");
            this.btnRun.remove();
            this.btnEmpty.remove();
        },

        _setOptions: function () {
            this._superApply(arguments);
        },
    });

});
