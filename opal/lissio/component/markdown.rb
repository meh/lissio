require 'base64'

module Lissio; class Component

class Markdown < Component
	def self.render(string, options = {}, &block)
		`marked(#{string.to_n}, #{options.to_n}, #{block.to_n})`
	end

	def self.content(string = nil)
		string ? @content = string : @content
	end

	def initialize(string = nil, options = {}, &block)
		@string  = string || self.class.content
		@options = options
		@block   = block

		unless @string
			raise ArgumentError, 'missing text to render'
		end
	end

	def render
		element.inner_html = Markdown.render(@string, @options, @block)

		super
	end
end

end; end

# load https://github.com/chjj/marked
`eval(#{Base64.decode64(DATA.read)})`

__END__

KGZ1bmN0aW9uKCl7ZnVuY3Rpb24gYShhKXt0aGlzLnRva2Vucz1bXSx0aGlzLnRva2Vucy5saW5r
cz17fSx0aGlzLm9wdGlvbnM9YXx8ai5kZWZhdWx0cyx0aGlzLnJ1bGVzPWsubm9ybWFsLHRoaXMu
b3B0aW9ucy5nZm0mJih0aGlzLm9wdGlvbnMudGFibGVzP3RoaXMucnVsZXM9ay50YWJsZXM6dGhp
cy5ydWxlcz1rLmdmbSl9ZnVuY3Rpb24gYihhLGIpe2lmKHRoaXMub3B0aW9ucz1ifHxqLmRlZmF1
bHRzLHRoaXMubGlua3M9YSx0aGlzLnJ1bGVzPWwubm9ybWFsLHRoaXMucmVuZGVyZXI9dGhpcy5v
cHRpb25zLnJlbmRlcmVyfHxuZXcgYyx0aGlzLnJlbmRlcmVyLm9wdGlvbnM9dGhpcy5vcHRpb25z
LCF0aGlzLmxpbmtzKXRocm93IG5ldyBFcnJvcigiVG9rZW5zIGFycmF5IHJlcXVpcmVzIGEgYGxp
bmtzYCBwcm9wZXJ0eS4iKTt0aGlzLm9wdGlvbnMuZ2ZtP3RoaXMub3B0aW9ucy5icmVha3M/dGhp
cy5ydWxlcz1sLmJyZWFrczp0aGlzLnJ1bGVzPWwuZ2ZtOnRoaXMub3B0aW9ucy5wZWRhbnRpYyYm
KHRoaXMucnVsZXM9bC5wZWRhbnRpYyl9ZnVuY3Rpb24gYyhhKXt0aGlzLm9wdGlvbnM9YXx8e319
ZnVuY3Rpb24gZChhKXt0aGlzLnRva2Vucz1bXSx0aGlzLnRva2VuPW51bGwsdGhpcy5vcHRpb25z
PWF8fGouZGVmYXVsdHMsdGhpcy5vcHRpb25zLnJlbmRlcmVyPXRoaXMub3B0aW9ucy5yZW5kZXJl
cnx8bmV3IGMsdGhpcy5yZW5kZXJlcj10aGlzLm9wdGlvbnMucmVuZGVyZXIsdGhpcy5yZW5kZXJl
ci5vcHRpb25zPXRoaXMub3B0aW9uc31mdW5jdGlvbiBlKGEsYil7cmV0dXJuIGEucmVwbGFjZShi
Py8mL2c6LyYoPyEjP1x3KzspL2csIiZhbXA7IikucmVwbGFjZSgvPC9nLCImbHQ7IikucmVwbGFj
ZSgvPi9nLCImZ3Q7IikucmVwbGFjZSgvIi9nLCImcXVvdDsiKS5yZXBsYWNlKC8nL2csIiYjMzk7
Iil9ZnVuY3Rpb24gZihhKXtyZXR1cm4gYS5yZXBsYWNlKC8mKCMoPzpcZCspfCg/OiN4WzAtOUEt
RmEtZl0rKXwoPzpcdyspKTs/L2csZnVuY3Rpb24oYSxiKXtyZXR1cm4gYj1iLnRvTG93ZXJDYXNl
KCksImNvbG9uIj09PWI/IjoiOiIjIj09PWIuY2hhckF0KDApPyJ4Ij09PWIuY2hhckF0KDEpP1N0
cmluZy5mcm9tQ2hhckNvZGUocGFyc2VJbnQoYi5zdWJzdHJpbmcoMiksMTYpKTpTdHJpbmcuZnJv
bUNoYXJDb2RlKCtiLnN1YnN0cmluZygxKSk6IiJ9KX1mdW5jdGlvbiBnKGEsYil7cmV0dXJuIGE9
YS5zb3VyY2UsYj1ifHwiIixmdW5jdGlvbiBjKGQsZSl7cmV0dXJuIGQ/KGU9ZS5zb3VyY2V8fGUs
ZT1lLnJlcGxhY2UoLyhefFteXFtdKVxeL2csIiQxIiksYT1hLnJlcGxhY2UoZCxlKSxjKTpuZXcg
UmVnRXhwKGEsYil9fWZ1bmN0aW9uIGgoKXt9ZnVuY3Rpb24gaShhKXtmb3IodmFyIGIsYyxkPTE7
ZDxhcmd1bWVudHMubGVuZ3RoO2QrKyl7Yj1hcmd1bWVudHNbZF07Zm9yKGMgaW4gYilPYmplY3Qu
cHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGwoYixjKSYmKGFbY109YltjXSl9cmV0dXJuIGF9
ZnVuY3Rpb24gaihiLGMsZil7aWYoZnx8ImZ1bmN0aW9uIj09dHlwZW9mIGMpe2Z8fChmPWMsYz1u
dWxsKSxjPWkoe30sai5kZWZhdWx0cyxjfHx7fSk7dmFyIGcsaCxrPWMuaGlnaGxpZ2h0LGw9MDt0
cnl7Zz1hLmxleChiLGMpfWNhdGNoKG0pe3JldHVybiBmKG0pfWg9Zy5sZW5ndGg7dmFyIG49ZnVu
Y3Rpb24oYSl7aWYoYSlyZXR1cm4gYy5oaWdobGlnaHQ9ayxmKGEpO3ZhciBiO3RyeXtiPWQucGFy
c2UoZyxjKX1jYXRjaChlKXthPWV9cmV0dXJuIGMuaGlnaGxpZ2h0PWssYT9mKGEpOmYobnVsbCxi
KX07aWYoIWt8fGsubGVuZ3RoPDMpcmV0dXJuIG4oKTtpZihkZWxldGUgYy5oaWdobGlnaHQsIWgp
cmV0dXJuIG4oKTtmb3IoO2w8Zy5sZW5ndGg7bCsrKSFmdW5jdGlvbihhKXtyZXR1cm4iY29kZSIh
PT1hLnR5cGU/LS1ofHxuKCk6ayhhLnRleHQsYS5sYW5nLGZ1bmN0aW9uKGIsYyl7cmV0dXJuIGI/
bihiKTpudWxsPT1jfHxjPT09YS50ZXh0Py0taHx8bigpOihhLnRleHQ9YyxhLmVzY2FwZWQ9ITAs
dm9pZCgtLWh8fG4oKSkpfSl9KGdbbF0pfWVsc2UgdHJ5e3JldHVybiBjJiYoYz1pKHt9LGouZGVm
YXVsdHMsYykpLGQucGFyc2UoYS5sZXgoYixjKSxjKX1jYXRjaChtKXtpZihtLm1lc3NhZ2UrPSJc
blBsZWFzZSByZXBvcnQgdGhpcyB0byBodHRwczovL2dpdGh1Yi5jb20vY2hqai9tYXJrZWQuIiwo
Y3x8ai5kZWZhdWx0cykuc2lsZW50KXJldHVybiI8cD5BbiBlcnJvciBvY2N1cmVkOjwvcD48cHJl
PiIrZShtLm1lc3NhZ2UrIiIsITApKyI8L3ByZT4iO3Rocm93IG19fXZhciBrPXtuZXdsaW5lOi9e
XG4rLyxjb2RlOi9eKCB7NH1bXlxuXStcbiopKy8sZmVuY2VzOmgsaHI6L14oICpbLSpfXSl7Myx9
ICooPzpcbit8JCkvLGhlYWRpbmc6L14gKigjezEsNn0pICooW15cbl0rPykgKiMqICooPzpcbit8
JCkvLG5wdGFibGU6aCxsaGVhZGluZzovXihbXlxuXSspXG4gKig9fC0pezIsfSAqKD86XG4rfCQp
LyxibG9ja3F1b3RlOi9eKCAqPlteXG5dKyhcbig/IWRlZilbXlxuXSspKlxuKikrLyxsaXN0Oi9e
KCAqKShidWxsKSBbXHNcU10rPyg/OmhyfGRlZnxcbnsyLH0oPyEgKSg/IVwxYnVsbCApXG4qfFxz
KiQpLyxodG1sOi9eICooPzpjb21tZW50ICooPzpcbnxccyokKXxjbG9zZWQgKig/OlxuezIsfXxc
cyokKXxjbG9zaW5nICooPzpcbnsyLH18XHMqJCkpLyxkZWY6L14gKlxbKFteXF1dKylcXTogKjw/
KFteXHM+XSspPj8oPzogK1siKF0oW15cbl0rKVsiKV0pPyAqKD86XG4rfCQpLyx0YWJsZTpoLHBh
cmFncmFwaDovXigoPzpbXlxuXStcbj8oPyFocnxoZWFkaW5nfGxoZWFkaW5nfGJsb2NrcXVvdGV8
dGFnfGRlZikpKylcbiovLHRleHQ6L15bXlxuXSsvfTtrLmJ1bGxldD0vKD86WyorLV18XGQrXC4p
LyxrLml0ZW09L14oICopKGJ1bGwpIFteXG5dKig/OlxuKD8hXDFidWxsIClbXlxuXSopKi8say5p
dGVtPWcoay5pdGVtLCJnbSIpKC9idWxsL2csay5idWxsZXQpKCksay5saXN0PWcoay5saXN0KSgv
YnVsbC9nLGsuYnVsbGV0KSgiaHIiLCJcXG4rKD89XFwxPyg/OlstKl9dICopezMsfSg/Olxcbit8
JCkpIikoImRlZiIsIlxcbisoPz0iK2suZGVmLnNvdXJjZSsiKSIpKCksay5ibG9ja3F1b3RlPWco
ay5ibG9ja3F1b3RlKSgiZGVmIixrLmRlZikoKSxrLl90YWc9Iig/ISg/OmF8ZW18c3Ryb25nfHNt
YWxsfHN8Y2l0ZXxxfGRmbnxhYmJyfGRhdGF8dGltZXxjb2RlfHZhcnxzYW1wfGtiZHxzdWJ8c3Vw
fGl8Ynx1fG1hcmt8cnVieXxydHxycHxiZGl8YmRvfHNwYW58YnJ8d2JyfGluc3xkZWx8aW1nKVxc
YilcXHcrKD8hOi98W15cXHdcXHNAXSpAKVxcYiIsay5odG1sPWcoay5odG1sKSgiY29tbWVudCIs
LzwhLS1bXHNcU10qPy0tPi8pKCJjbG9zZWQiLC88KHRhZylbXHNcU10rPzxcL1wxPi8pKCJjbG9z
aW5nIiwvPHRhZyg/OiJbXiJdKiJ8J1teJ10qJ3xbXiciPl0pKj8+LykoL3RhZy9nLGsuX3RhZyko
KSxrLnBhcmFncmFwaD1nKGsucGFyYWdyYXBoKSgiaHIiLGsuaHIpKCJoZWFkaW5nIixrLmhlYWRp
bmcpKCJsaGVhZGluZyIsay5saGVhZGluZykoImJsb2NrcXVvdGUiLGsuYmxvY2txdW90ZSkoInRh
ZyIsIjwiK2suX3RhZykoImRlZiIsay5kZWYpKCksay5ub3JtYWw9aSh7fSxrKSxrLmdmbT1pKHt9
LGsubm9ybWFsLHtmZW5jZXM6L14gKihgezMsfXx+ezMsfSlbIFwuXSooXFMrKT8gKlxuKFtcc1xT
XSo/KVxzKlwxICooPzpcbit8JCkvLHBhcmFncmFwaDovXi8saGVhZGluZzovXiAqKCN7MSw2fSkg
KyhbXlxuXSs/KSAqIyogKig/OlxuK3wkKS99KSxrLmdmbS5wYXJhZ3JhcGg9ZyhrLnBhcmFncmFw
aCkoIig/ISIsIig/ISIray5nZm0uZmVuY2VzLnNvdXJjZS5yZXBsYWNlKCJcXDEiLCJcXDIiKSsi
fCIray5saXN0LnNvdXJjZS5yZXBsYWNlKCJcXDEiLCJcXDMiKSsifCIpKCksay50YWJsZXM9aSh7
fSxrLmdmbSx7bnB0YWJsZTovXiAqKFxTLipcfC4qKVxuICooWy06XSsgKlx8Wy18IDpdKilcbigo
PzouKlx8LiooPzpcbnwkKSkqKVxuKi8sdGFibGU6L14gKlx8KC4rKVxuICpcfCggKlstOl0rWy18
IDpdKilcbigoPzogKlx8LiooPzpcbnwkKSkqKVxuKi99KSxhLnJ1bGVzPWssYS5sZXg9ZnVuY3Rp
b24oYixjKXt2YXIgZD1uZXcgYShjKTtyZXR1cm4gZC5sZXgoYil9LGEucHJvdG90eXBlLmxleD1m
dW5jdGlvbihhKXtyZXR1cm4gYT1hLnJlcGxhY2UoL1xyXG58XHIvZywiXG4iKS5yZXBsYWNlKC9c
dC9nLCIgICAgIikucmVwbGFjZSgvXHUwMGEwL2csIiAiKS5yZXBsYWNlKC9cdTI0MjQvZywiXG4i
KSx0aGlzLnRva2VuKGEsITApfSxhLnByb3RvdHlwZS50b2tlbj1mdW5jdGlvbihhLGIsYyl7Zm9y
KHZhciBkLGUsZixnLGgsaSxqLGwsbSxhPWEucmVwbGFjZSgvXiArJC9nbSwiIik7YTspaWYoKGY9
dGhpcy5ydWxlcy5uZXdsaW5lLmV4ZWMoYSkpJiYoYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCks
ZlswXS5sZW5ndGg+MSYmdGhpcy50b2tlbnMucHVzaCh7dHlwZToic3BhY2UifSkpLGY9dGhpcy5y
dWxlcy5jb2RlLmV4ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksZj1mWzBdLnJlcGxh
Y2UoL14gezR9L2dtLCIiKSx0aGlzLnRva2Vucy5wdXNoKHt0eXBlOiJjb2RlIix0ZXh0OnRoaXMu
b3B0aW9ucy5wZWRhbnRpYz9mOmYucmVwbGFjZSgvXG4rJC8sIiIpfSk7ZWxzZSBpZihmPXRoaXMu
cnVsZXMuZmVuY2VzLmV4ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksdGhpcy50b2tl
bnMucHVzaCh7dHlwZToiY29kZSIsbGFuZzpmWzJdLHRleHQ6ZlszXXx8IiJ9KTtlbHNlIGlmKGY9
dGhpcy5ydWxlcy5oZWFkaW5nLmV4ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksdGhp
cy50b2tlbnMucHVzaCh7dHlwZToiaGVhZGluZyIsZGVwdGg6ZlsxXS5sZW5ndGgsdGV4dDpmWzJd
fSk7ZWxzZSBpZihiJiYoZj10aGlzLnJ1bGVzLm5wdGFibGUuZXhlYyhhKSkpe2ZvcihhPWEuc3Vi
c3RyaW5nKGZbMF0ubGVuZ3RoKSxpPXt0eXBlOiJ0YWJsZSIsaGVhZGVyOmZbMV0ucmVwbGFjZSgv
XiAqfCAqXHwgKiQvZywiIikuc3BsaXQoLyAqXHwgKi8pLGFsaWduOmZbMl0ucmVwbGFjZSgvXiAq
fFx8ICokL2csIiIpLnNwbGl0KC8gKlx8ICovKSxjZWxsczpmWzNdLnJlcGxhY2UoL1xuJC8sIiIp
LnNwbGl0KCJcbiIpfSxsPTA7bDxpLmFsaWduLmxlbmd0aDtsKyspL14gKi0rOiAqJC8udGVzdChp
LmFsaWduW2xdKT9pLmFsaWduW2xdPSJyaWdodCI6L14gKjotKzogKiQvLnRlc3QoaS5hbGlnblts
XSk/aS5hbGlnbltsXT0iY2VudGVyIjovXiAqOi0rICokLy50ZXN0KGkuYWxpZ25bbF0pP2kuYWxp
Z25bbF09ImxlZnQiOmkuYWxpZ25bbF09bnVsbDtmb3IobD0wO2w8aS5jZWxscy5sZW5ndGg7bCsr
KWkuY2VsbHNbbF09aS5jZWxsc1tsXS5zcGxpdCgvICpcfCAqLyk7dGhpcy50b2tlbnMucHVzaChp
KX1lbHNlIGlmKGY9dGhpcy5ydWxlcy5saGVhZGluZy5leGVjKGEpKWE9YS5zdWJzdHJpbmcoZlsw
XS5sZW5ndGgpLHRoaXMudG9rZW5zLnB1c2goe3R5cGU6ImhlYWRpbmciLGRlcHRoOiI9Ij09PWZb
Ml0/MToyLHRleHQ6ZlsxXX0pO2Vsc2UgaWYoZj10aGlzLnJ1bGVzLmhyLmV4ZWMoYSkpYT1hLnN1
YnN0cmluZyhmWzBdLmxlbmd0aCksdGhpcy50b2tlbnMucHVzaCh7dHlwZToiaHIifSk7ZWxzZSBp
ZihmPXRoaXMucnVsZXMuYmxvY2txdW90ZS5leGVjKGEpKWE9YS5zdWJzdHJpbmcoZlswXS5sZW5n
dGgpLHRoaXMudG9rZW5zLnB1c2goe3R5cGU6ImJsb2NrcXVvdGVfc3RhcnQifSksZj1mWzBdLnJl
cGxhY2UoL14gKj4gPy9nbSwiIiksdGhpcy50b2tlbihmLGIsITApLHRoaXMudG9rZW5zLnB1c2go
e3R5cGU6ImJsb2NrcXVvdGVfZW5kIn0pO2Vsc2UgaWYoZj10aGlzLnJ1bGVzLmxpc3QuZXhlYyhh
KSl7Zm9yKGE9YS5zdWJzdHJpbmcoZlswXS5sZW5ndGgpLGc9ZlsyXSx0aGlzLnRva2Vucy5wdXNo
KHt0eXBlOiJsaXN0X3N0YXJ0IixvcmRlcmVkOmcubGVuZ3RoPjF9KSxmPWZbMF0ubWF0Y2godGhp
cy5ydWxlcy5pdGVtKSxkPSExLG09Zi5sZW5ndGgsbD0wO20+bDtsKyspaT1mW2xdLGo9aS5sZW5n
dGgsaT1pLnJlcGxhY2UoL14gKihbKistXXxcZCtcLikgKy8sIiIpLH5pLmluZGV4T2YoIlxuICIp
JiYoai09aS5sZW5ndGgsaT10aGlzLm9wdGlvbnMucGVkYW50aWM/aS5yZXBsYWNlKC9eIHsxLDR9
L2dtLCIiKTppLnJlcGxhY2UobmV3IFJlZ0V4cCgiXiB7MSwiK2orIn0iLCJnbSIpLCIiKSksdGhp
cy5vcHRpb25zLnNtYXJ0TGlzdHMmJmwhPT1tLTEmJihoPWsuYnVsbGV0LmV4ZWMoZltsKzFdKVsw
XSxnPT09aHx8Zy5sZW5ndGg+MSYmaC5sZW5ndGg+MXx8KGE9Zi5zbGljZShsKzEpLmpvaW4oIlxu
IikrYSxsPW0tMSkpLGU9ZHx8L1xuXG4oPyFccyokKS8udGVzdChpKSxsIT09bS0xJiYoZD0iXG4i
PT09aS5jaGFyQXQoaS5sZW5ndGgtMSksZXx8KGU9ZCkpLHRoaXMudG9rZW5zLnB1c2goe3R5cGU6
ZT8ibG9vc2VfaXRlbV9zdGFydCI6Imxpc3RfaXRlbV9zdGFydCJ9KSx0aGlzLnRva2VuKGksITEs
YyksdGhpcy50b2tlbnMucHVzaCh7dHlwZToibGlzdF9pdGVtX2VuZCJ9KTt0aGlzLnRva2Vucy5w
dXNoKHt0eXBlOiJsaXN0X2VuZCJ9KX1lbHNlIGlmKGY9dGhpcy5ydWxlcy5odG1sLmV4ZWMoYSkp
YT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksdGhpcy50b2tlbnMucHVzaCh7dHlwZTp0aGlzLm9w
dGlvbnMuc2FuaXRpemU/InBhcmFncmFwaCI6Imh0bWwiLHByZTohdGhpcy5vcHRpb25zLnNhbml0
aXplciYmKCJwcmUiPT09ZlsxXXx8InNjcmlwdCI9PT1mWzFdfHwic3R5bGUiPT09ZlsxXSksdGV4
dDpmWzBdfSk7ZWxzZSBpZighYyYmYiYmKGY9dGhpcy5ydWxlcy5kZWYuZXhlYyhhKSkpYT1hLnN1
YnN0cmluZyhmWzBdLmxlbmd0aCksdGhpcy50b2tlbnMubGlua3NbZlsxXS50b0xvd2VyQ2FzZSgp
XT17aHJlZjpmWzJdLHRpdGxlOmZbM119O2Vsc2UgaWYoYiYmKGY9dGhpcy5ydWxlcy50YWJsZS5l
eGVjKGEpKSl7Zm9yKGE9YS5zdWJzdHJpbmcoZlswXS5sZW5ndGgpLGk9e3R5cGU6InRhYmxlIixo
ZWFkZXI6ZlsxXS5yZXBsYWNlKC9eICp8ICpcfCAqJC9nLCIiKS5zcGxpdCgvICpcfCAqLyksYWxp
Z246ZlsyXS5yZXBsYWNlKC9eICp8XHwgKiQvZywiIikuc3BsaXQoLyAqXHwgKi8pLGNlbGxzOmZb
M10ucmVwbGFjZSgvKD86ICpcfCAqKT9cbiQvLCIiKS5zcGxpdCgiXG4iKX0sbD0wO2w8aS5hbGln
bi5sZW5ndGg7bCsrKS9eICotKzogKiQvLnRlc3QoaS5hbGlnbltsXSk/aS5hbGlnbltsXT0icmln
aHQiOi9eICo6LSs6ICokLy50ZXN0KGkuYWxpZ25bbF0pP2kuYWxpZ25bbF09ImNlbnRlciI6L14g
KjotKyAqJC8udGVzdChpLmFsaWduW2xdKT9pLmFsaWduW2xdPSJsZWZ0IjppLmFsaWduW2xdPW51
bGw7Zm9yKGw9MDtsPGkuY2VsbHMubGVuZ3RoO2wrKylpLmNlbGxzW2xdPWkuY2VsbHNbbF0ucmVw
bGFjZSgvXiAqXHwgKnwgKlx8ICokL2csIiIpLnNwbGl0KC8gKlx8ICovKTt0aGlzLnRva2Vucy5w
dXNoKGkpfWVsc2UgaWYoYiYmKGY9dGhpcy5ydWxlcy5wYXJhZ3JhcGguZXhlYyhhKSkpYT1hLnN1
YnN0cmluZyhmWzBdLmxlbmd0aCksdGhpcy50b2tlbnMucHVzaCh7dHlwZToicGFyYWdyYXBoIix0
ZXh0OiJcbiI9PT1mWzFdLmNoYXJBdChmWzFdLmxlbmd0aC0xKT9mWzFdLnNsaWNlKDAsLTEpOmZb
MV19KTtlbHNlIGlmKGY9dGhpcy5ydWxlcy50ZXh0LmV4ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBd
Lmxlbmd0aCksdGhpcy50b2tlbnMucHVzaCh7dHlwZToidGV4dCIsdGV4dDpmWzBdfSk7ZWxzZSBp
ZihhKXRocm93IG5ldyBFcnJvcigiSW5maW5pdGUgbG9vcCBvbiBieXRlOiAiK2EuY2hhckNvZGVB
dCgwKSk7cmV0dXJuIHRoaXMudG9rZW5zfTt2YXIgbD17ZXNjYXBlOi9eXFwoW1xcYCp7fVxbXF0o
KSMrXC0uIV8+XSkvLGF1dG9saW5rOi9ePChbXiA+XSsoQHw6XC8pW14gPl0rKT4vLHVybDpoLHRh
ZzovXjwhLS1bXHNcU10qPy0tPnxePFwvP1x3Kyg/OiJbXiJdKiJ8J1teJ10qJ3xbXiciPl0pKj8+
LyxsaW5rOi9eIT9cWyhpbnNpZGUpXF1cKGhyZWZcKS8scmVmbGluazovXiE/XFsoaW5zaWRlKVxd
XHMqXFsoW15cXV0qKVxdLyxub2xpbms6L14hP1xbKCg/OlxbW15cXV0qXF18W15cW1xdXSkqKVxd
LyxzdHJvbmc6L15fXyhbXHNcU10rPylfXyg/IV8pfF5cKlwqKFtcc1xTXSs/KVwqXCooPyFcKikv
LGVtOi9eXGJfKCg/OlteX118X18pKz8pX1xifF5cKigoPzpcKlwqfFtcc1xTXSkrPylcKig/IVwq
KS8sY29kZTovXihgKylccyooW1xzXFNdKj9bXmBdKVxzKlwxKD8hYCkvLGJyOi9eIHsyLH1cbig/
IVxzKiQpLyxkZWw6aCx0ZXh0Oi9eW1xzXFNdKz8oPz1bXFw8IVxbXypgXXwgezIsfVxufCQpL307
bC5faW5zaWRlPS8oPzpcW1teXF1dKlxdfFteXFtcXV18XF0oPz1bXlxbXSpcXSkpKi8sbC5faHJl
Zj0vXHMqPD8oW1xzXFNdKj8pPj8oPzpccytbJyJdKFtcc1xTXSo/KVsnIl0pP1xzKi8sbC5saW5r
PWcobC5saW5rKSgiaW5zaWRlIixsLl9pbnNpZGUpKCJocmVmIixsLl9ocmVmKSgpLGwucmVmbGlu
az1nKGwucmVmbGluaykoImluc2lkZSIsbC5faW5zaWRlKSgpLGwubm9ybWFsPWkoe30sbCksbC5w
ZWRhbnRpYz1pKHt9LGwubm9ybWFsLHtzdHJvbmc6L15fXyg/PVxTKShbXHNcU10qP1xTKV9fKD8h
Xyl8XlwqXCooPz1cUykoW1xzXFNdKj9cUylcKlwqKD8hXCopLyxlbTovXl8oPz1cUykoW1xzXFNd
Kj9cUylfKD8hXyl8XlwqKD89XFMpKFtcc1xTXSo/XFMpXCooPyFcKikvfSksbC5nZm09aSh7fSxs
Lm5vcm1hbCx7ZXNjYXBlOmcobC5lc2NhcGUpKCJdKSIsIn58XSkiKSgpLHVybDovXihodHRwcz86
XC9cL1teXHM8XStbXjwuLDo7IicpXF1cc10pLyxkZWw6L15+fig/PVxTKShbXHNcU10qP1xTKX5+
Lyx0ZXh0OmcobC50ZXh0KSgiXXwiLCJ+XXwiKSgifCIsInxodHRwcz86Ly98IikoKX0pLGwuYnJl
YWtzPWkoe30sbC5nZm0se2JyOmcobC5icikoInsyLH0iLCIqIikoKSx0ZXh0OmcobC5nZm0udGV4
dCkoInsyLH0iLCIqIikoKX0pLGIucnVsZXM9bCxiLm91dHB1dD1mdW5jdGlvbihhLGMsZCl7dmFy
IGU9bmV3IGIoYyxkKTtyZXR1cm4gZS5vdXRwdXQoYSl9LGIucHJvdG90eXBlLm91dHB1dD1mdW5j
dGlvbihhKXtmb3IodmFyIGIsYyxkLGYsZz0iIjthOylpZihmPXRoaXMucnVsZXMuZXNjYXBlLmV4
ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksZys9ZlsxXTtlbHNlIGlmKGY9dGhpcy5y
dWxlcy5hdXRvbGluay5leGVjKGEpKWE9YS5zdWJzdHJpbmcoZlswXS5sZW5ndGgpLCJAIj09PWZb
Ml0/KGM9IjoiPT09ZlsxXS5jaGFyQXQoNik/dGhpcy5tYW5nbGUoZlsxXS5zdWJzdHJpbmcoNykp
OnRoaXMubWFuZ2xlKGZbMV0pLGQ9dGhpcy5tYW5nbGUoIm1haWx0bzoiKStjKTooYz1lKGZbMV0p
LGQ9YyksZys9dGhpcy5yZW5kZXJlci5saW5rKGQsbnVsbCxjKTtlbHNlIGlmKHRoaXMuaW5MaW5r
fHwhKGY9dGhpcy5ydWxlcy51cmwuZXhlYyhhKSkpe2lmKGY9dGhpcy5ydWxlcy50YWcuZXhlYyhh
KSkhdGhpcy5pbkxpbmsmJi9ePGEgL2kudGVzdChmWzBdKT90aGlzLmluTGluaz0hMDp0aGlzLmlu
TGluayYmL148XC9hPi9pLnRlc3QoZlswXSkmJih0aGlzLmluTGluaz0hMSksYT1hLnN1YnN0cmlu
ZyhmWzBdLmxlbmd0aCksZys9dGhpcy5vcHRpb25zLnNhbml0aXplP3RoaXMub3B0aW9ucy5zYW5p
dGl6ZXI/dGhpcy5vcHRpb25zLnNhbml0aXplcihmWzBdKTplKGZbMF0pOmZbMF07ZWxzZSBpZihm
PXRoaXMucnVsZXMubGluay5leGVjKGEpKWE9YS5zdWJzdHJpbmcoZlswXS5sZW5ndGgpLHRoaXMu
aW5MaW5rPSEwLGcrPXRoaXMub3V0cHV0TGluayhmLHtocmVmOmZbMl0sdGl0bGU6ZlszXX0pLHRo
aXMuaW5MaW5rPSExO2Vsc2UgaWYoKGY9dGhpcy5ydWxlcy5yZWZsaW5rLmV4ZWMoYSkpfHwoZj10
aGlzLnJ1bGVzLm5vbGluay5leGVjKGEpKSl7aWYoYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCks
Yj0oZlsyXXx8ZlsxXSkucmVwbGFjZSgvXHMrL2csIiAiKSxiPXRoaXMubGlua3NbYi50b0xvd2Vy
Q2FzZSgpXSwhYnx8IWIuaHJlZil7Zys9ZlswXS5jaGFyQXQoMCksYT1mWzBdLnN1YnN0cmluZygx
KSthO2NvbnRpbnVlfXRoaXMuaW5MaW5rPSEwLGcrPXRoaXMub3V0cHV0TGluayhmLGIpLHRoaXMu
aW5MaW5rPSExfWVsc2UgaWYoZj10aGlzLnJ1bGVzLnN0cm9uZy5leGVjKGEpKWE9YS5zdWJzdHJp
bmcoZlswXS5sZW5ndGgpLGcrPXRoaXMucmVuZGVyZXIuc3Ryb25nKHRoaXMub3V0cHV0KGZbMl18
fGZbMV0pKTtlbHNlIGlmKGY9dGhpcy5ydWxlcy5lbS5leGVjKGEpKWE9YS5zdWJzdHJpbmcoZlsw
XS5sZW5ndGgpLGcrPXRoaXMucmVuZGVyZXIuZW0odGhpcy5vdXRwdXQoZlsyXXx8ZlsxXSkpO2Vs
c2UgaWYoZj10aGlzLnJ1bGVzLmNvZGUuZXhlYyhhKSlhPWEuc3Vic3RyaW5nKGZbMF0ubGVuZ3Ro
KSxnKz10aGlzLnJlbmRlcmVyLmNvZGVzcGFuKGUoZlsyXSwhMCkpO2Vsc2UgaWYoZj10aGlzLnJ1
bGVzLmJyLmV4ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksZys9dGhpcy5yZW5kZXJl
ci5icigpO2Vsc2UgaWYoZj10aGlzLnJ1bGVzLmRlbC5leGVjKGEpKWE9YS5zdWJzdHJpbmcoZlsw
XS5sZW5ndGgpLGcrPXRoaXMucmVuZGVyZXIuZGVsKHRoaXMub3V0cHV0KGZbMV0pKTtlbHNlIGlm
KGY9dGhpcy5ydWxlcy50ZXh0LmV4ZWMoYSkpYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksZys9
dGhpcy5yZW5kZXJlci50ZXh0KGUodGhpcy5zbWFydHlwYW50cyhmWzBdKSkpO2Vsc2UgaWYoYSl0
aHJvdyBuZXcgRXJyb3IoIkluZmluaXRlIGxvb3Agb24gYnl0ZTogIithLmNoYXJDb2RlQXQoMCkp
fWVsc2UgYT1hLnN1YnN0cmluZyhmWzBdLmxlbmd0aCksYz1lKGZbMV0pLGQ9YyxnKz10aGlzLnJl
bmRlcmVyLmxpbmsoZCxudWxsLGMpO3JldHVybiBnfSxiLnByb3RvdHlwZS5vdXRwdXRMaW5rPWZ1
bmN0aW9uKGEsYil7dmFyIGM9ZShiLmhyZWYpLGQ9Yi50aXRsZT9lKGIudGl0bGUpOm51bGw7cmV0
dXJuIiEiIT09YVswXS5jaGFyQXQoMCk/dGhpcy5yZW5kZXJlci5saW5rKGMsZCx0aGlzLm91dHB1
dChhWzFdKSk6dGhpcy5yZW5kZXJlci5pbWFnZShjLGQsZShhWzFdKSl9LGIucHJvdG90eXBlLnNt
YXJ0eXBhbnRzPWZ1bmN0aW9uKGEpe3JldHVybiB0aGlzLm9wdGlvbnMuc21hcnR5cGFudHM/YS5y
ZXBsYWNlKC8tLS0vZywi4oCUIikucmVwbGFjZSgvLS0vZywi4oCTIikucmVwbGFjZSgvKF58Wy1c
dTIwMTRcLyhcW3siXHNdKScvZywiJDHigJgiKS5yZXBsYWNlKC8nL2csIuKAmSIpLnJlcGxhY2Uo
LyhefFstXHUyMDE0XC8oXFt7XHUyMDE4XHNdKSIvZywiJDHigJwiKS5yZXBsYWNlKC8iL2csIuKA
nSIpLnJlcGxhY2UoL1wuezN9L2csIuKApiIpOmF9LGIucHJvdG90eXBlLm1hbmdsZT1mdW5jdGlv
bihhKXtpZighdGhpcy5vcHRpb25zLm1hbmdsZSlyZXR1cm4gYTtmb3IodmFyIGIsYz0iIixkPWEu
bGVuZ3RoLGU9MDtkPmU7ZSsrKWI9YS5jaGFyQ29kZUF0KGUpLE1hdGgucmFuZG9tKCk+LjUmJihi
PSJ4IitiLnRvU3RyaW5nKDE2KSksYys9IiYjIitiKyI7IjtyZXR1cm4gY30sYy5wcm90b3R5cGUu
Y29kZT1mdW5jdGlvbihhLGIsYyl7aWYodGhpcy5vcHRpb25zLmhpZ2hsaWdodCl7dmFyIGQ9dGhp
cy5vcHRpb25zLmhpZ2hsaWdodChhLGIpO251bGwhPWQmJmQhPT1hJiYoYz0hMCxhPWQpfXJldHVy
biBiPyc8cHJlPjxjb2RlIGNsYXNzPSInK3RoaXMub3B0aW9ucy5sYW5nUHJlZml4K2UoYiwhMCkr
JyI+JysoYz9hOmUoYSwhMCkpKyJcbjwvY29kZT48L3ByZT5cbiI6IjxwcmU+PGNvZGU+IisoYz9h
OmUoYSwhMCkpKyJcbjwvY29kZT48L3ByZT4ifSxjLnByb3RvdHlwZS5ibG9ja3F1b3RlPWZ1bmN0
aW9uKGEpe3JldHVybiI8YmxvY2txdW90ZT5cbiIrYSsiPC9ibG9ja3F1b3RlPlxuIn0sYy5wcm90
b3R5cGUuaHRtbD1mdW5jdGlvbihhKXtyZXR1cm4gYX0sYy5wcm90b3R5cGUuaGVhZGluZz1mdW5j
dGlvbihhLGIsYyl7cmV0dXJuIjxoIitiKycgaWQ9IicrdGhpcy5vcHRpb25zLmhlYWRlclByZWZp
eCtjLnRvTG93ZXJDYXNlKCkucmVwbGFjZSgvW15cd10rL2csIi0iKSsnIj4nK2ErIjwvaCIrYisi
PlxuIn0sYy5wcm90b3R5cGUuaHI9ZnVuY3Rpb24oKXtyZXR1cm4gdGhpcy5vcHRpb25zLnhodG1s
PyI8aHIvPlxuIjoiPGhyPlxuIn0sYy5wcm90b3R5cGUubGlzdD1mdW5jdGlvbihhLGIpe3ZhciBj
PWI/Im9sIjoidWwiO3JldHVybiI8IitjKyI+XG4iK2ErIjwvIitjKyI+XG4ifSxjLnByb3RvdHlw
ZS5saXN0aXRlbT1mdW5jdGlvbihhKXtyZXR1cm4iPGxpPiIrYSsiPC9saT5cbiJ9LGMucHJvdG90
eXBlLnBhcmFncmFwaD1mdW5jdGlvbihhKXtyZXR1cm4iPHA+IithKyI8L3A+XG4ifSxjLnByb3Rv
dHlwZS50YWJsZT1mdW5jdGlvbihhLGIpe3JldHVybiI8dGFibGU+XG48dGhlYWQ+XG4iK2ErIjwv
dGhlYWQ+XG48dGJvZHk+XG4iK2IrIjwvdGJvZHk+XG48L3RhYmxlPlxuIn0sYy5wcm90b3R5cGUu
dGFibGVyb3c9ZnVuY3Rpb24oYSl7cmV0dXJuIjx0cj5cbiIrYSsiPC90cj5cbiJ9LGMucHJvdG90
eXBlLnRhYmxlY2VsbD1mdW5jdGlvbihhLGIpe3ZhciBjPWIuaGVhZGVyPyJ0aCI6InRkIixkPWIu
YWxpZ24/IjwiK2MrJyBzdHlsZT0idGV4dC1hbGlnbjonK2IuYWxpZ24rJyI+JzoiPCIrYysiPiI7
cmV0dXJuIGQrYSsiPC8iK2MrIj5cbiJ9LGMucHJvdG90eXBlLnN0cm9uZz1mdW5jdGlvbihhKXty
ZXR1cm4iPHN0cm9uZz4iK2ErIjwvc3Ryb25nPiJ9LGMucHJvdG90eXBlLmVtPWZ1bmN0aW9uKGEp
e3JldHVybiI8ZW0+IithKyI8L2VtPiJ9LGMucHJvdG90eXBlLmNvZGVzcGFuPWZ1bmN0aW9uKGEp
e3JldHVybiI8Y29kZT4iK2ErIjwvY29kZT4ifSxjLnByb3RvdHlwZS5icj1mdW5jdGlvbigpe3Jl
dHVybiB0aGlzLm9wdGlvbnMueGh0bWw/Ijxici8+IjoiPGJyPiJ9LGMucHJvdG90eXBlLmRlbD1m
dW5jdGlvbihhKXtyZXR1cm4iPGRlbD4iK2ErIjwvZGVsPiJ9LGMucHJvdG90eXBlLmxpbms9ZnVu
Y3Rpb24oYSxiLGMpe2lmKHRoaXMub3B0aW9ucy5zYW5pdGl6ZSl7dHJ5e3ZhciBkPWRlY29kZVVS
SUNvbXBvbmVudChmKGEpKS5yZXBsYWNlKC9bXlx3Ol0vZywiIikudG9Mb3dlckNhc2UoKX1jYXRj
aChlKXtyZXR1cm4iIn1pZigwPT09ZC5pbmRleE9mKCJqYXZhc2NyaXB0OiIpfHwwPT09ZC5pbmRl
eE9mKCJ2YnNjcmlwdDoiKXx8MD09PWQuaW5kZXhPZigiZGF0YToiKSlyZXR1cm4iIn12YXIgZz0n
PGEgaHJlZj0iJythKyciJztyZXR1cm4gYiYmKGcrPScgdGl0bGU9IicrYisnIicpLGcrPSI+Iitj
KyI8L2E+In0sYy5wcm90b3R5cGUuaW1hZ2U9ZnVuY3Rpb24oYSxiLGMpe3ZhciBkPSc8aW1nIHNy
Yz0iJythKyciIGFsdD0iJytjKyciJztyZXR1cm4gYiYmKGQrPScgdGl0bGU9IicrYisnIicpLGQr
PXRoaXMub3B0aW9ucy54aHRtbD8iLz4iOiI+In0sYy5wcm90b3R5cGUudGV4dD1mdW5jdGlvbihh
KXtyZXR1cm4gYX0sZC5wYXJzZT1mdW5jdGlvbihhLGIsYyl7dmFyIGU9bmV3IGQoYixjKTtyZXR1
cm4gZS5wYXJzZShhKX0sZC5wcm90b3R5cGUucGFyc2U9ZnVuY3Rpb24oYSl7dGhpcy5pbmxpbmU9
bmV3IGIoYS5saW5rcyx0aGlzLm9wdGlvbnMsdGhpcy5yZW5kZXJlciksdGhpcy50b2tlbnM9YS5y
ZXZlcnNlKCk7Zm9yKHZhciBjPSIiO3RoaXMubmV4dCgpOyljKz10aGlzLnRvaygpO3JldHVybiBj
fSxkLnByb3RvdHlwZS5uZXh0PWZ1bmN0aW9uKCl7cmV0dXJuIHRoaXMudG9rZW49dGhpcy50b2tl
bnMucG9wKCl9LGQucHJvdG90eXBlLnBlZWs9ZnVuY3Rpb24oKXtyZXR1cm4gdGhpcy50b2tlbnNb
dGhpcy50b2tlbnMubGVuZ3RoLTFdfHwwfSxkLnByb3RvdHlwZS5wYXJzZVRleHQ9ZnVuY3Rpb24o
KXtmb3IodmFyIGE9dGhpcy50b2tlbi50ZXh0OyJ0ZXh0Ij09PXRoaXMucGVlaygpLnR5cGU7KWEr
PSJcbiIrdGhpcy5uZXh0KCkudGV4dDtyZXR1cm4gdGhpcy5pbmxpbmUub3V0cHV0KGEpfSxkLnBy
b3RvdHlwZS50b2s9ZnVuY3Rpb24oKXtzd2l0Y2godGhpcy50b2tlbi50eXBlKXtjYXNlInNwYWNl
IjpyZXR1cm4iIjtjYXNlImhyIjpyZXR1cm4gdGhpcy5yZW5kZXJlci5ocigpO2Nhc2UiaGVhZGlu
ZyI6cmV0dXJuIHRoaXMucmVuZGVyZXIuaGVhZGluZyh0aGlzLmlubGluZS5vdXRwdXQodGhpcy50
b2tlbi50ZXh0KSx0aGlzLnRva2VuLmRlcHRoLHRoaXMudG9rZW4udGV4dCk7Y2FzZSJjb2RlIjpy
ZXR1cm4gdGhpcy5yZW5kZXJlci5jb2RlKHRoaXMudG9rZW4udGV4dCx0aGlzLnRva2VuLmxhbmcs
dGhpcy50b2tlbi5lc2NhcGVkKTtjYXNlInRhYmxlIjp2YXIgYSxiLGMsZCxlLGY9IiIsZz0iIjtm
b3IoYz0iIixhPTA7YTx0aGlzLnRva2VuLmhlYWRlci5sZW5ndGg7YSsrKWQ9e2hlYWRlcjohMCxh
bGlnbjp0aGlzLnRva2VuLmFsaWduW2FdfSxjKz10aGlzLnJlbmRlcmVyLnRhYmxlY2VsbCh0aGlz
LmlubGluZS5vdXRwdXQodGhpcy50b2tlbi5oZWFkZXJbYV0pLHtoZWFkZXI6ITAsYWxpZ246dGhp
cy50b2tlbi5hbGlnblthXX0pO2ZvcihmKz10aGlzLnJlbmRlcmVyLnRhYmxlcm93KGMpLGE9MDth
PHRoaXMudG9rZW4uY2VsbHMubGVuZ3RoO2ErKyl7Zm9yKGI9dGhpcy50b2tlbi5jZWxsc1thXSxj
PSIiLGU9MDtlPGIubGVuZ3RoO2UrKyljKz10aGlzLnJlbmRlcmVyLnRhYmxlY2VsbCh0aGlzLmlu
bGluZS5vdXRwdXQoYltlXSkse2hlYWRlcjohMSxhbGlnbjp0aGlzLnRva2VuLmFsaWduW2VdfSk7
Zys9dGhpcy5yZW5kZXJlci50YWJsZXJvdyhjKX1yZXR1cm4gdGhpcy5yZW5kZXJlci50YWJsZShm
LGcpO2Nhc2UiYmxvY2txdW90ZV9zdGFydCI6Zm9yKHZhciBnPSIiOyJibG9ja3F1b3RlX2VuZCIh
PT10aGlzLm5leHQoKS50eXBlOylnKz10aGlzLnRvaygpO3JldHVybiB0aGlzLnJlbmRlcmVyLmJs
b2NrcXVvdGUoZyk7Y2FzZSJsaXN0X3N0YXJ0Ijpmb3IodmFyIGc9IiIsaD10aGlzLnRva2VuLm9y
ZGVyZWQ7Imxpc3RfZW5kIiE9PXRoaXMubmV4dCgpLnR5cGU7KWcrPXRoaXMudG9rKCk7cmV0dXJu
IHRoaXMucmVuZGVyZXIubGlzdChnLGgpO2Nhc2UibGlzdF9pdGVtX3N0YXJ0Ijpmb3IodmFyIGc9
IiI7Imxpc3RfaXRlbV9lbmQiIT09dGhpcy5uZXh0KCkudHlwZTspZys9InRleHQiPT09dGhpcy50
b2tlbi50eXBlP3RoaXMucGFyc2VUZXh0KCk6dGhpcy50b2soKTtyZXR1cm4gdGhpcy5yZW5kZXJl
ci5saXN0aXRlbShnKTtjYXNlImxvb3NlX2l0ZW1fc3RhcnQiOmZvcih2YXIgZz0iIjsibGlzdF9p
dGVtX2VuZCIhPT10aGlzLm5leHQoKS50eXBlOylnKz10aGlzLnRvaygpO3JldHVybiB0aGlzLnJl
bmRlcmVyLmxpc3RpdGVtKGcpO2Nhc2UiaHRtbCI6dmFyIGk9dGhpcy50b2tlbi5wcmV8fHRoaXMu
b3B0aW9ucy5wZWRhbnRpYz90aGlzLnRva2VuLnRleHQ6dGhpcy5pbmxpbmUub3V0cHV0KHRoaXMu
dG9rZW4udGV4dCk7cmV0dXJuIHRoaXMucmVuZGVyZXIuaHRtbChpKTtjYXNlInBhcmFncmFwaCI6
cmV0dXJuIHRoaXMucmVuZGVyZXIucGFyYWdyYXBoKHRoaXMuaW5saW5lLm91dHB1dCh0aGlzLnRv
a2VuLnRleHQpKTtjYXNlInRleHQiOnJldHVybiB0aGlzLnJlbmRlcmVyLnBhcmFncmFwaCh0aGlz
LnBhcnNlVGV4dCgpKX19LGguZXhlYz1oLGoub3B0aW9ucz1qLnNldE9wdGlvbnM9ZnVuY3Rpb24o
YSl7cmV0dXJuIGkoai5kZWZhdWx0cyxhKSxqfSxqLmRlZmF1bHRzPXtnZm06ITAsdGFibGVzOiEw
LGJyZWFrczohMSxwZWRhbnRpYzohMSxzYW5pdGl6ZTohMSxzYW5pdGl6ZXI6bnVsbCxtYW5nbGU6
ITAsc21hcnRMaXN0czohMSxzaWxlbnQ6ITEsaGlnaGxpZ2h0Om51bGwsbGFuZ1ByZWZpeDoibGFu
Zy0iLHNtYXJ0eXBhbnRzOiExLGhlYWRlclByZWZpeDoiIixyZW5kZXJlcjpuZXcgYyx4aHRtbDoh
MX0sai5QYXJzZXI9ZCxqLnBhcnNlcj1kLnBhcnNlLGouUmVuZGVyZXI9YyxqLkxleGVyPWEsai5s
ZXhlcj1hLmxleCxqLklubGluZUxleGVyPWIsai5pbmxpbmVMZXhlcj1iLm91dHB1dCxqLnBhcnNl
PWosInVuZGVmaW5lZCIhPXR5cGVvZiBtb2R1bGUmJiJvYmplY3QiPT10eXBlb2YgZXhwb3J0cz9t
b2R1bGUuZXhwb3J0cz1qOiJmdW5jdGlvbiI9PXR5cGVvZiBkZWZpbmUmJmRlZmluZS5hbWQ/ZGVm
aW5lKGZ1bmN0aW9uKCl7cmV0dXJuIGp9KTp0aGlzLm1hcmtlZD1qfSkuY2FsbChmdW5jdGlvbigp
e3JldHVybiB0aGlzfHwoInVuZGVmaW5lZCIhPXR5cGVvZiB3aW5kb3c/d2luZG93Omdsb2JhbCl9
KCkpOw==
