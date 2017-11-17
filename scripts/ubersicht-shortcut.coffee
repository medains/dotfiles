# 
# useful shortcuts
# Colin Ameigh
# 

emailCopy: "/Users/ameighc/bin/e"
shrugCopy: "LANG=\"en_GB.UTF-8\" /Users/ameighc/bin/shrug"

refreshFrequency: false

render: (output) -> """
  <div id="email">&#x1f4e8;</div>
  <div id="shrug">&#x00af;\\_(&#x30c4;)_/&#x00af;</div>
"""

afterRender: (domEl) ->
    $(domEl).on 'click', '#email', => @run @emailCopy
    $(domEl).on 'click', '#shrug', => @run @shrugCopy

style: """
  background: rgba(#fff, 0)
  box-sizing: border-box
  color: #ddd
  font-family: Helvetica Neue
  font-weight: 800
  font-smoothing: antialiased
  font-size: 42px
  margin-left: 10px
  bottom: 10%
  left: 0%
  text-align: justify
  text-shadow: black 0px 0px 2px

  div
    valign: center
    float: left
    overflow: hidden
"""
