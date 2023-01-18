var validated = false;
var input = document.querySelector("#phone");
var iti = window.intlTelInput(input, {
  utilsScript: "https://cdn.jsdelivr.net/npm/intl-tel-input@16.0.3/build/js/utils.js",
  initialCountry: "auto",
  geoIpLookup: function(success, failure) {
    $.get("https://ipinfo.io", function() {}, "jsonp").always(function(resp) {
      var countryCode = (resp && resp.country) ? resp.country : "br";
      success(countryCode);
    });
  },
});

(function ($) {

 $('form').on('submit', function(e) {
   e.preventDefault();
   e.stopPropagation();

   let form = $(this).get(0);
   $('form').addClass('was-validated');

   //Need to display invalid feedback explicitly on submit for input fields due to plugin changing structure
   $('form #phone').each(function() {
       let telInput = $(this).get(0);
       if($(this).prop('required') && !telInput.checkValidity()) {
         $(this).parents('.form-group').find('.invalid-feedback').show();
       }
     });

 if(validated) {
   //let phoneNumber = iti.getNumber().substring(1);
  // window.open('whatsapp://send/?&text&type=phone_number&app_absent=0&phone='+phoneNumber)
     $('#phonelink')[0].click();
 };
   });
  
  input.addEventListener("countrychange", function() {
    let isValidNumber = iti.isValidNumber();
    checkPhoneValidation($(this), isValidNumber);
  });

  $('form').on('keyup', '.tel-input', function (event) {
    let isValidNumber = iti.isValidNumber();
    checkPhoneValidation($(this), isValidNumber);
  });
  

})(jQuery);  

function checkPhoneValidation(element, isValidNumber)
{

  let invFeedbackDiv = element.parents('.form-group').find('.invalid-feedback');
  input = element.get(0);

      if(isValidNumber) {
        input.setCustomValidity('');
    }
  
  if(isValidNumber && input.validity.valid) {
    // whatsapp://send/?phone=5535987080608&text&type=phone_number&app_absent=0
    input.setCustomValidity('');
    invFeedbackDiv.hide();
    validated = true;
  } else {
    invFeedbackDiv.html('Invalid phone number');
    input.setCustomValidity('Insira somente numeros');

    if($('form').hasClass('was-validated')) {
      invFeedbackDiv.show();
    }
    validated = false;
  } 
 
 if(validated) {
   let uri = 'whatsapp://send/?&text&type=phone_number&app_absent=0&phone='+iti.getNumber().substring(1);
    $('#phonelink').attr('href', uri);
 } else {
     $('#phonelink').attr('href', '#');
 };
}

