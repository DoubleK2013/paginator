'use strick'

class Paginator
    construtor: (cfg) ->
        @init cfg

    configure: (cfg) ->
        @cfg = $.extend true, {}, @cfg or @defaults, cfg
        @selector = @cfg.selector

        unless @selector then throw 'Need selector to find the container!'

        @$paginator = $ @selector

        @page = @cfg.page
        @total = @cfg.total
        @pageSize = @cfg.pageSize
        @maxPage = @cfg.maxPage

        @showPage = @cfg.showPage
        @render()
        return this

    addEvent: ->
        @$paginator.on 'click.paginator.api', 'li a', (e) =>
            target = e.currentTarget
            $target = $ target
            page = $target.data 'page-api'

            if $target.hasClass('disable') or $target.hasClass 'current' then return

            if page is '-'
                page = if @page - 1 > 0 then @page - 1 else 1
            else if page is '+'
                page = if @page + 1 < @maxPage then @page + 1 else  @maxPage
            else 
                page = parseInt page, 10

            @cfg.pagination.page = page

            @configure @cfg

            if typeof @cfg.callback is 'function' then @cfg.callback.call target, page

        return this

    render: ->
        pages = @calcPageItems()
        $ul = $ '<ul>'
        for page in pages
            $ul.append @createPageItem page
        @$paginator.html $ul
        return this

    calcPageItems: ->
        pages = []
        pages.push '-'
        if @maxPage > @showPage
            pages.push page for page in [1..@maxPage]
        else
            if @page < @showPage - 1
                pages.push page for page in [1..@showPage - 2]
                pages.push '.'
            else if @maxPage - @page < @showPage - 2
                papes.push 1
                papes.push '.'
                pages.push page for page in [@maxPage - @showPage + 3..@maxPage]
            else
                range = @showPage - 4
                rangeHalf = range // 2
                pages.push 1
                pages.push '.'
                pages.push page for page in [@page - rangeHalf...@page - rangeHalf + range]
                pages.push '.'
                pages.push @maxPage
        pages.push '+'
        return pages

    createItem: (page) ->
        $a = $('<a>').data('page-api', page).attr
            'href': 'javascript:void(0)'
        clazz = ''
        if page is '.'
            $a = '...'
        else if page is '-'
            clazz = 'disable' if @page is 1
            $a.addClass(clazz).append('Prev ')
        else if page is '+'
            clazz = 'disable' if @page is @maxPage
            $a.addClass(clazz).append(' Next')
        else
            clazz = 'current' if @page is page
            $a.addClass(clazz).text page
        return $('<li>').append($a)

    Paginator::defaults =
        page: 1,
        total: 0,
        pageSize: 10,
        maxPage: 1,
        showPage: 10

api = (cfg) ->
    paginator = $(cfg.selector).data 'paginator'
    if paginator?
        paginator.configure cfg
    else
        paginator = new Paginator cfg
        $(cfg.selector).data 'paginator', paginator
    return paginator

window.paginator = api


