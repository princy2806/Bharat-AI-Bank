import { LightningElement } from 'lwc';

export default class BharatBankDashboard extends LightningElement {

    // ── Open the Agentforce / Embedded Service Chat ───────────────────
    openChat() {
        // Salesforce Messaging for Web / Embedded Service selectors
        const selectors = [
            'button[title="Open Chat"]',
            'button[title="Chat with an Expert"]',
            '.embeddedServiceSidebarButton',
            '.sidebarMinimized button',
            '[data-aura-class*="embeddedService"] button',
            'embeddedservice-chat-header button',
            '.embedded-chat-button',
            'button[class*="embeddedService"]'
        ];

        let opened = false;
        for (const sel of selectors) {
            const btn = document.querySelector(sel);
            if (btn) { btn.click(); opened = true; break; }
        }

        if (!opened) {
            // Fire a custom event — works if Experience Cloud page has a listener
            const evt = new CustomEvent('openagentchat', { bubbles: true, composed: true });
            this.dispatchEvent(evt);
        }
    }

    // ── Quick action handlers ─────────────────────────────────────────
    handleBalance() {
        this._chatWith('What is my current account balance?');
    }

    handleStatement() {
        this._chatWith('Show me my mini statement with the last 5 transactions.');
    }

    handleDispute() {
        this._chatWith('I want to file a credit card dispute for an unauthorized transaction.');
    }

    handleEMI() {
        this._chatWith('I want to explore loan EMI restructuring options for my home loan.');
    }

    handleCallback() {
        this._chatWith('Please schedule a Relationship Manager callback for me.');
    }

    viewAccounts() {
        this._chatWith('Show me a summary of all my accounts — savings, credit card, and home loan.');
    }

    // ── Internal: open chat then pre-fill message ─────────────────────
    _chatWith(message) {
        this.openChat();

        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setTimeout(() => {
            const inputSelectors = [
                'input[placeholder*="Message"]',
                'input[placeholder*="Type"]',
                'textarea[placeholder*="Message"]',
                'textarea[placeholder*="Type"]',
                'textarea[placeholder*="message"]',
                '.cEmbeddedServiceChat input',
                '.sidebarInputAndFooter input',
                '.embeddedServiceLiveAgentStateChatInputFooter input',
                '.embeddedServiceLiveAgentStateChatInputFooter textarea',
                '[data-aura-class*="chatInput"] input',
                'input[class*="chatInput"]'
            ];

            let chatInput = null;
            for (const sel of inputSelectors) {
                chatInput = document.querySelector(sel);
                if (chatInput) break;
            }

            if (chatInput) {
                // Set native value then fire React-style change events
                const nativeInputValueSetter = Object.getOwnPropertyDescriptor(
                    window.HTMLInputElement.prototype, 'value'
                );
                if (nativeInputValueSetter) {
                    nativeInputValueSetter.set.call(chatInput, message);
                } else {
                    chatInput.value = message;
                }
                chatInput.dispatchEvent(new Event('input',  { bubbles: true }));
                chatInput.dispatchEvent(new Event('change', { bubbles: true }));
                chatInput.focus();
            }
        }, 900);
    }
}
