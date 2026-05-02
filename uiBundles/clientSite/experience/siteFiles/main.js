// Minimal client site JS (vanilla, small SPA) - copied into Experience siteFiles
const el = (tag, attrs = {}, ...children) => {
  const node = document.createElement(tag);
  Object.entries(attrs).forEach(([k, v]) => node.setAttribute(k, v));
  children.flat().forEach(c => node.appendChild(typeof c === 'string' ? document.createTextNode(c) : c));
  return node;
};

function nav() {
  const navEl = el('nav', { class: 'site-nav' },
    el('a', { href: '#/' }, 'Home'),
    el('a', { href: '#/about' }, 'About'),
    el('a', { href: '#/contact' }, 'Contact')
  );
  return navEl;
}

function home() {
  return el('section', { class: 'page home' },
    el('h1', {}, 'Welcome to the Client Site'),
    el('p', {}, 'This is a lightweight, deployable client-facing site scaffold for the Agentforce Hackathon project.'),
    el('div', { class: 'cards' },
      el('div', { class: 'card' },
        el('h3', {}, 'Accounts'),
        el('p', {}, 'Display customer accounts and summaries.')
      ),
      el('div', { class: 'card' },
        el('h3', {}, 'Transactions'),
        el('p', {}, 'Show recent transactions and dispute status.')
      ),
      el('div', { class: 'card' },
        el('h3', {}, 'Support'),
        el('p', {}, 'Open disputes or contact support.')
      )
    )
  );
}

function about() {
  return el('section', { class: 'page about' },
    el('h1', {}, 'About this Project'),
    el('p', {}, 'Built as a UI bundle scaffold to connect to the Salesforce backend. Use this as a starting point for building richer experiences.')
  );
}

function contact() {
  return el('section', { class: 'page contact' },
    el('h1', {}, 'Contact Us'),
    el('p', {}, 'For demo purposes, contact the project owner.')
  );
}

function render() {
  const root = document.getElementById('root');
  root.innerHTML = '';
  root.appendChild(nav());

  const hash = location.hash.replace('#', '') || '/';
  let page;
  if (hash === '/' || hash === '') page = home();
  else if (hash.startsWith('/about')) page = about();
  else if (hash.startsWith('/contact')) page = contact();
  else page = el('section', { class: 'page' }, el('h1', {}, 'Not Found'));

  root.appendChild(page);
}

window.addEventListener('hashchange', render);
window.addEventListener('load', render);