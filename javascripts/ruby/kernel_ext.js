!function(r){var e=r.top,t=r.nil,n=(r.breaker,r.slice),o=r.module;return r.add_stubs(["$join","$collect","$to_s"]),function(e){{var u=o(e,"Kernel"),l=u._proto;u._scope}l.$puts=function(r){var e,o,u,l=this,i=t;return r=n.call(arguments,0),i=(e=(o=r).$collect,e._p=(u=function(r){u._s||this;return null==r&&(r=t),r.$to_s()},u._s=l,u),e).call(o).$join(" "),OpalCore.puts(i)},l.$require=function(r){return OpalCore.require(r)},r.donate(u,["$puts","$require"])}(e)}(Opal);