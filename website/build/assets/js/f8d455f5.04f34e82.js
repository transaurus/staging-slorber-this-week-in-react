"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([["1163"],{68093:function(e,n,t){t.r(n),t.d(n,{default:()=>m,frontMatter:()=>d,metadata:()=>i,assets:()=>u,toc:()=>h,contentTitle:()=>p});var i=JSON.parse('{"type":"mdx","permalink":"/emailCodeBlock","source":"@site/src/pages/emailCodeBlock.mdx","title":"EmailCodeBlock","frontMatter":{"isTranslationMissing":false},"unlisted":false}'),o=t("24246"),r=t("80980"),l=t("27378"),a=t("58142");let s=`function subscribe(callback) {
  window.addEventListener("online", callback);
  window.addEventListener("offline", callback);
  return () => {
    window.removeEventListener("online", callback);
    window.removeEventListener("offline", callback);
  };
}

function useOnlineStatus() {
  return useSyncExternalStore(
    subscribe,
    () => navigator.onLine,
    () => true
  );
}

function ChatIndicator() {
  const isOnline = useOnlineStatus();
  // ...
}

function useSyncExternalStore<Snapshot>(
  subscribe: (onStoreChange: () => void) => () => void,
  getSnapshot: () => Snapshot,
  getServerSnapshot?: () => Snapshot
): Snapshot;`;function c(e){let n=(0,l.useRef)(),[t,i]=(0,l.useState)(""),r=async()=>{let e=n.current.querySelector("pre");Array.from(e.querySelectorAll("div.token-line")).forEach(e=>{!function(e){let n=document.createElement("span");for(n.style="font-size: 12px; line-height: 16px;";e.firstChild;)n.appendChild(e.firstChild);console.log({parentNode:e.parentNode,div:e,span:n}),e.parentNode.replaceChild(n,e),n.nextSibling&&n.parentNode.insertBefore(document.createElement("br"),n.nextSibling)}(e)});let t=e.innerHTML,o=`<pre style="background-color: #f6f8fa; font-size: 12px; line-height: 16px; border-radius: 5px; padding: 5px; margin: 0; border: 0;">
<code style="font-size: 12px; line-height: 16px;">${t}</code></pre>`;console.log({emailHTML:o}),await navigator.clipboard.writeText(o),console.log("copied to clipboard"),i(o)};return(0,o.jsxs)("div",{ref:n,className:"emailCodeBlock_ZH3H",children:[(0,o.jsx)(a.Z,{...e,language:"typescript",children:s}),(0,o.jsx)("button",{style:{margin:5},onClick:r,children:"Copy to email"}),t&&(0,o.jsxs)("div",{style:{marginTop:10},children:[(0,o.jsx)("h1",{children:"Copied to clipboard:"}),(0,o.jsx)("div",{dangerouslySetInnerHTML:{__html:t}})]})]})}let d={isTranslationMissing:!1},p="EmailCodeBlock",u={},h=[];function f(e){let n={h1:"h1",header:"header",...(0,r.a)(),...e.components};return(0,o.jsxs)(o.Fragment,{children:[(0,o.jsx)(n.header,{children:(0,o.jsx)(n.h1,{id:"emailcodeblock",children:"EmailCodeBlock"})}),"\n","\n",(0,o.jsx)(c,{})]})}function m(e={}){let{wrapper:n}={...(0,r.a)(),...e.components};return n?(0,o.jsx)(n,{...e,children:(0,o.jsx)(f,{...e})}):f(e)}}}]);