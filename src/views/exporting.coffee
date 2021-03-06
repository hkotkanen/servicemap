define [
    'underscore'
    'URI'
    'backbone'
    'cs!app/views/base'
    'cs!app/views/context-menu'
    'cs!app/p13n'
    'i18next'
], (_, URI, Backbone, base, ContextMenu, p13n, i18n) ->

    # TODO: rename to tool menu
    class ExportingView extends base.SMLayout
        template: 'exporting'
        regions:
            exportingContext: '#exporting-context'
        events:
            'click': 'openMenu'
        openMenu: (ev) ->
            ev.preventDefault()
            ev.stopPropagation()
            if @exportingContext.currentView?
                @exportingContext.reset()
                return
            models = [
                # TODO: implement functionality
                # new Backbone.Model
                #     name: i18n.t 'tools.link_action'
                #     action: _.bind @linkAction, @
                #     icon: 'outbound-link'
                # new Backbone.Model
                #     name: i18n.t 'tools.share_action'
                #     action: _.bind @shareAction, @
                #     icon: 'outbound-link'
                new Backbone.Model
                    name: i18n.t 'tools.embed_action'
                    action: _.bind @embedAction, @
                    icon: 'outbound-link'
                new Backbone.Model
                    name: i18n.t 'tools.feedback_action'
                    action: _.bind @feedbackAction, @
                    icon: 'feedback'
                new Backbone.Model
                    name: i18n.t 'tools.info_action'
                    action: _.bind @infoAction, @
                    icon: 'info'
            ]
            menu = new ContextMenu collection: new Backbone.Collection models
            @exportingContext.show menu
            $(document).one 'click', (ev) =>
                @exportingContext.reset()
        linkAction: (ev) ->
            console.log 'link action clicked'
        shareAction: (ev) ->
            console.log 'share action clicked'
        embedAction: (ev) ->
            url = URI window.location.href
            directory = url.directory()
            directory = '/embedder' + directory
            url.directory directory
            url.port ''
            query = url.search true
            query.bbox = @getMapBoundsBbox()
            city = p13n.get 'city'
            if city?
                query.city = city
            background = p13n.get('map_background_layer')
            if background not in ['servicemap', 'guidemap']
                query.map = background
            query.ratio = parseInt(100 * window.innerHeight / window.innerWidth)
            url.search query
            window.location.href = url.toString()
        feedbackAction: (ev) ->
            console.log 'feedback action clicked'
        infoAction: (ev) ->
            app.commands.execute 'showServiceMapDescription'
        getMapBoundsBbox: ->
            # TODO: don't break architecture thusly
            __you_shouldnt_access_me_like_this = window.mapView.map
            wrongBbox = __you_shouldnt_access_me_like_this._originalGetBounds().toBBoxString().split ','
            rightBbox = _.map [1,0,3,2], (i) -> wrongBbox[i].slice(0,8)
            rightBbox.join ','
        render: ->
            super()
            @el
