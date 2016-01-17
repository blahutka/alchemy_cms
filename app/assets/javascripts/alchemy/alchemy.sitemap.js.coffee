#= require date-formatter

window.Alchemy = {} if typeof(window.Alchemy) is 'undefined'

# The admin sitemap Alchemy module
Alchemy.Sitemap =

  # Storing some objects.
  init: ->
    @search_field = $("#search_field")
    @filter_field_clear = $('.js_filter_field_clear')
    @display = $('#page_filter_result')
    @items = $(".sitemap_page", '#sitemap')
    @_observe()
    @watchPagePublicationState()
    true

  # Filters the sitemap
  filter: (term) ->
    results = []
    self = Alchemy.Sitemap
    self.items.map ->
      item = $(this)
      if term != '' && item.attr('name').toLowerCase().indexOf(term) != -1
        item.addClass('highlight')
        item.removeClass('no-match')
        results.push item
      else
        item.addClass('no-match')
        item.removeClass('highlight')
    self.filter_field_clear.show()
    length = results.length
    if length == 1
      self.display.show().text("1 #{Alchemy._t('page_found')}")
      $.scrollTo(results[0], {duration: 400, offset: -80})
    else if length > 1
      self.display.show().text("#{length} #{Alchemy._t('pages_found')}")
    else
      self.items.removeClass('no-match highlight')
      self.display.hide()
      $.scrollTo('0', 400)
      self.filter_field_clear.hide()

  # Adds onkey up observer to search field
  _observe: ->
    filter = @filter
    @search_field.on 'keyup', ->
      term = $(this).val()
      filter(term.toLowerCase())
    @search_field.on 'focus', ->
      key.setScope('search')
    @filter_field_clear.click =>
      @search_field.val('')
      filter('')

  # Handles the page publication date fields
  watchPagePublicationState: ->
    $(document).on 'DialogReady.Alchemy', (e, $dialog) ->
      $public_on_field = $('#page_public_on', $dialog)
      $public_until_field = $('#page_public_until', $dialog)
      $publication_date_fields = $('.page-publication-date-fields', $dialog)

      $('#page_public', $dialog).click ->
        $checkbox = $(this)
        format = $checkbox.data('date-format')
        now = new Date()
        if $checkbox.is(':checked')
          $publication_date_fields.removeClass('hidden')
          $public_on_field.val Date.format(now, format)
        else
          $publication_date_fields.addClass('hidden')
          $public_on_field.val('')
        $public_until_field.val('')
        true

    return
