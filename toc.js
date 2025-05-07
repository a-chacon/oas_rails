// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded affix "><a href="index.html">Introduction</a></li><li class="chapter-item expanded affix "><li class="part-title">User Guide</li><li class="chapter-item expanded "><a href="installation.html"><strong aria-hidden="true">1.</strong> Installation</a></li><li class="chapter-item expanded "><a href="configuration/index.html"><strong aria-hidden="true">2.</strong> Configuration</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="configuration/cors.html"><strong aria-hidden="true">2.1.</strong> Cors</a></li><li class="chapter-item expanded "><a href="configuration/securing.html"><strong aria-hidden="true">2.2.</strong> Securing</a></li><li class="chapter-item expanded "><a href="configuration/customizing_view.html"><strong aria-hidden="true">2.3.</strong> Customizing View</a></li></ol></li><li class="chapter-item expanded "><li class="part-title">Usage</li><li class="chapter-item expanded "><a href="tags/index.html"><strong aria-hidden="true">3.</strong> Tags</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="tags/summary.html"><strong aria-hidden="true">3.1.</strong> @summary</a></li><li class="chapter-item expanded "><a href="tags/parameter.html"><strong aria-hidden="true">3.2.</strong> @parameter</a></li><li class="chapter-item expanded "><a href="tags/request_body.html"><strong aria-hidden="true">3.3.</strong> @request_body</a></li><li class="chapter-item expanded "><a href="tags/request_body_example.html"><strong aria-hidden="true">3.4.</strong> @request_body_example</a></li><li class="chapter-item expanded "><a href="tags/response.html"><strong aria-hidden="true">3.5.</strong> @response</a></li><li class="chapter-item expanded "><a href="tags/response_example.html"><strong aria-hidden="true">3.6.</strong> @response_example</a></li><li class="chapter-item expanded "><a href="tags/tags.html"><strong aria-hidden="true">3.7.</strong> @tags</a></li><li class="chapter-item expanded "><a href="tags/no_auth.html"><strong aria-hidden="true">3.8.</strong> @no_auth</a></li><li class="chapter-item expanded "><a href="tags/auth.html"><strong aria-hidden="true">3.9.</strong> @auth</a></li><li class="chapter-item expanded "><a href="tags/oas_include.html"><strong aria-hidden="true">3.10.</strong> @oas_include</a></li></ol></li><li class="chapter-item expanded "><a href="examples.html"><strong aria-hidden="true">4.</strong> Examples</a></li><li class="chapter-item expanded affix "><li class="spacer"></li><li class="chapter-item expanded affix "><li class="part-title">Others</li><li class="chapter-item expanded "><a href="llmstxt.html"><strong aria-hidden="true">5.</strong> Friendly LLMs Docs (llmstxt)</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0].split("?")[0];
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
