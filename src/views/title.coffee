define [
    'cs!app/p13n',
    'cs!app/jade',
    'cs!app/views/base',
], (
    p13n,
    jade,
    base
)  ->

    class TitleView extends base.SMItemView
        className:
            'title-control'
        render: =>
            @el.innerHTML = jade.template 'title-view', lang: p13n.getLanguage(), root: appSettings.url_prefix
            @el

    class LandingTitleView extends base.SMItemView
        template: 'landing-title-view'
        id: 'title'
        className: 'landing-title-control'
        initialize: ->
            @listenTo(app.vent, 'title-view:hide', @hideTitleView)
            @listenTo(app.vent, 'title-view:show', @unHideTitleView)
        serializeData: ->
            isHidden: @isHidden
            lang: p13n.getLanguage()
        hideTitleView: ->
            $('body').removeClass 'landing'
            @isHidden = true
            @render()
        unHideTitleView: ->
            $('body').addClass 'landing'
            @isHidden = false
            @render()

    TitleView: TitleView
    LandingTitleView: LandingTitleView
