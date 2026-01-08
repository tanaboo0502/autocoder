// AutoCoder Manual Site - JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Highlight current page in navigation
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-links a');

    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath ||
            currentPath.endsWith(link.getAttribute('href'))) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Copy code functionality
    document.querySelectorAll('.code-block').forEach(block => {
        const header = block.querySelector('.code-header');
        if (header) {
            const copyBtn = document.createElement('button');
            copyBtn.className = 'copy-btn';
            copyBtn.textContent = 'Copy';
            copyBtn.style.cssText = `
                background: rgba(99, 102, 241, 0.2);
                border: 1px solid rgba(99, 102, 241, 0.3);
                color: #94a3b8;
                padding: 0.25rem 0.75rem;
                border-radius: 0.25rem;
                cursor: pointer;
                font-size: 0.75rem;
                float: right;
                transition: all 0.2s ease;
            `;

            copyBtn.addEventListener('mouseover', () => {
                copyBtn.style.background = 'rgba(99, 102, 241, 0.3)';
            });

            copyBtn.addEventListener('mouseout', () => {
                copyBtn.style.background = 'rgba(99, 102, 241, 0.2)';
            });

            copyBtn.addEventListener('click', () => {
                const code = block.querySelector('code');
                if (code) {
                    navigator.clipboard.writeText(code.textContent).then(() => {
                        copyBtn.textContent = 'Copied!';
                        copyBtn.style.color = '#22c55e';
                        setTimeout(() => {
                            copyBtn.textContent = 'Copy';
                            copyBtn.style.color = '#94a3b8';
                        }, 2000);
                    });
                }
            });

            header.appendChild(copyBtn);
        }
    });

    // Mobile menu toggle
    const sidebar = document.querySelector('.sidebar');
    if (window.innerWidth <= 768) {
        const menuToggle = document.createElement('button');
        menuToggle.className = 'menu-toggle';
        menuToggle.innerHTML = '☰ Menu';
        menuToggle.style.cssText = `
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1000;
            background: var(--surface-color);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            cursor: pointer;
        `;

        document.body.appendChild(menuToggle);

        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('show');
        });
    }
});
