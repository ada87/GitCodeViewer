function scrollGallery(id, dir) {
  const el = document.getElementById(id);
  if (!el) {
    return;
  }

  const slide = el.querySelector(".gallery-slide");
  if (!slide) {
    return;
  }

  const scrollAmount = slide.offsetWidth + 16;
  el.scrollBy({ left: dir * scrollAmount, behavior: "smooth" });
}

function switchDevice(device) {
  const phoneWrapper = document.getElementById("phone-wrapper");
  const tabletWrapper = document.getElementById("tablet-wrapper");
  if (!phoneWrapper || !tabletWrapper) {
    return;
  }

  phoneWrapper.style.display = device === "phone" ? "flex" : "none";
  tabletWrapper.style.display = device === "tablet" ? "flex" : "none";

  const tabs = document.querySelectorAll(".gallery-tab");
  tabs.forEach((tab, i) => {
    const isPhoneTab = i === 0 && device === "phone";
    const isTabletTab = i === 1 && device === "tablet";
    tab.classList.toggle("active", isPhoneTab || isTabletTab);
  });
}

function getCurrentLocaleSlug() {
  const path = (window.location.pathname || "/").toLowerCase();
  const supported = ["zh-cn", "es", "pt-br", "hi", "ja", "de", "fr", "ko", "id", "tr"];
  for (const slug of supported) {
    if (path === `/${slug}` || path.startsWith(`/${slug}/`)) {
      return slug;
    }
  }
  return "en";
}

function setActiveLocaleLink() {
  const currentLocale = getCurrentLocaleSlug();
  const links = document.querySelectorAll(".i18n-link[data-locale]");
  links.forEach((link) => {
    link.classList.toggle("active", link.getAttribute("data-locale") === currentLocale);
  });
}

setActiveLocaleLink();
