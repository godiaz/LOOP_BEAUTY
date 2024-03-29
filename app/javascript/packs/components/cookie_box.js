cookieClose = document.querySelectorAll('.close-cookie-box');
cookieBox = document.querySelector('.cookie-box');

if (cookieBox) {
  setTimeout(function() {
    if (window.innerWidth < 576) {
      cookieBox.style.bottom = '0' + 'px'
    } else {
      cookieBox.style.bottom = '30' + 'px'
    }
    }, 2000
  )
}

if (cookieClose) {
  cookieClose.forEach((close) => {
    close.addEventListener('click', () => {
      cookieBox.style.opacity = '0'
      setTimeout(function() {
        cookieBox.style.display = 'none'
        }, 500
      )
    })
  })
}

