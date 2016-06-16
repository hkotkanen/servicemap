define [
    'underscore',
    'app/p13n',
    'app/views/base',
    'app/data-visualization'
], (
    _,
    p13n,
    base,
    dataviz
)  ->

    class ServiceCartView extends base.SMItemView
        template: 'service-cart'
        tagName: 'ul'
        className: 'expanded container main-list'
        events: ->
            'click .personalisation-container .maximizer': 'maximize'
            'keydown .personalisation-container .maximizer': @keyboardHandler @maximize, ['space', 'enter']
            'click .button.cart-close-button': 'minimize'
            'click .button.close-button': 'closeService'
            'keydown .button.close-button': @keyboardHandler @closeService, ['space', 'enter']
            'click input': 'selectLayerInput'
            'click .map-layer label': 'selectLayerLabel'
            # 'click .data-layer a.toggle-layer': 'toggleDataLayer'
            'click .data-layer label': 'toggleDataLayer'
        initialize: (opts) ->
            @collection = opts.collection
            @listenTo @collection, 'add', @maximize
            @listenTo @collection, 'remove', =>
                if @collection.length
                    @render()
                else
                    @minimize()
            @listenTo @collection, 'reset', @render
            @listenTo @collection, 'minmax', @render
            @listenTo p13n, 'change', (path, value) =>
                if path[0] == 'map_background_layer' then @render()
            if @collection.length
                @minimized = false
            else
                @minimized = true
        maximize: ->
            @minimized = false
            @collection.trigger 'minmax'
        minimize: ->
            @minimized = true
            @collection.trigger 'minmax'
        onRender: ->
            if @minimized
                @$el.removeClass 'expanded'
                @$el.addClass 'minimized'
            else
                @$el.addClass 'expanded'
                @$el.removeClass 'minimized'
                _.defer =>
                    @$el.find('input:checked').first().focus()
        serializeData: ->
            if @minimized
                return minimized: true
            data = super()
            data.layers = p13n.getMapBackgroundLayers()
            data.datalayers = dataviz.HEATMAP_DATASETS
            # console.log data.layers
            data
        closeService: (ev) ->
            app.commands.execute 'removeService', $(ev.currentTarget).data('service')
        toggleDataLayer: (ev) ->
            # console.log $(ev.target)
            # app.commands.execute 'addDataLayer', 'popdensity:RTV201412'
            app.commands.execute 'addDataLayer', $(ev.target)[0].innerText.trim()
        _selectLayer: (value) ->
            p13n.setMapBackgroundLayer value
        selectLayerInput: (ev) ->
            @_selectLayer $(ev.currentTarget).attr('value')
        selectLayerLabel: (ev) ->
            @_selectLayer $(ev.currentTarget).data('layer')
