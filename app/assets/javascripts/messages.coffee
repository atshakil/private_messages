$ ->
  $(".local-time").each (index) ->
    jq_time = $ this
    jq_time.text new Date(jq_time.text()).toLocaleString()
