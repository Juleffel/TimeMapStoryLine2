###################
# UTILS
###################
# Small functions for dates
window.j_date = (str_date)->
  new Date(Date.parse(str_date))
window.jv_date = (str_date)->
  j_date(str_date).valueOf()
window.json_data = ($block, attr) ->
  JSON.parse($block.data(attr))
window.blank = (str)->
  (!str? || (str.length == 0))
Object.size = (obj) ->
  size = 0
  for key of obj
    if obj.hasOwnProperty(key)
      size++
  return size