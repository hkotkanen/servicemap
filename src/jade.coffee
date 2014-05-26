define 'app/jade', ['underscore', 'jquery', 'i18next', 'app/p13n'], (_, $, i18n, p13n) ->
    # Make sure jade runtime is loaded
    if typeof jade != 'object'
        raise "Jade not loaded before app"

    set_helper = (data, name, helper) ->
        if name of data
            return
        data[name] = helper

    class Jade
        get_template: (name) ->
            key = "views/templates/#{name}"
            if key not of JST
                throw "template '#{name}' not loaded"
            template_func = JST[key]
            return template_func

        t_attr: (attr) ->
            return p13n.get_translated_attr attr
        t_attr_has_lang: (attr) ->
            if not attr
                return false
            return p13n.get_language() of attr
        phone_i18n: (num) ->
            if num.indexOf '0' == 0
                # FIXME: make configurable
                num = '+358' + num.substring 1
            num = num.replace /\s/g, ''
            num = num.replace /-/g, ''
            return num

        template: (name, locals) ->
            if locals?
                if typeof locals != 'object'
                    throw "template must get an object argument"
            else
                locals = {}
            func = @get_template name
            data = _.clone locals
            set_helper data, 't', i18n.t
            set_helper data, 't_attr', @t_attr
            set_helper data, 't_attr_has_lang', @t_attr_has_lang
            set_helper data, 'phone_i18n', @phone_i18n
            template_str = func data
            return $.trim template_str

    return new Jade
