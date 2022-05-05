function Logar() {
    event.preventDefault();

    var usuario = window.document.getElementById("edtUsuario").value;
    var senha = window.document.getElementById("edtSenha").value;



    var myHeaders = new Headers();
    myHeaders.append("X-USER", usuario);
    myHeaders.append("X-PASS", senha);
    myHeaders.append("Authorization", "Basic QWRtaW46QWFTbEDDp1EqaFQldlFNcHZ6");

    var requestOptions = {
        method: 'GET',
        headers: myHeaders,
        redirect: 'follow'
    };

    fetch("http://192.168.10.15:9000/login", requestOptions)
        .then(async(response) => { // STATUS: 404 OU 500 vai definir ok para false
            if (response.ok) {
                return window.location.href = "../Project/page/index.html";
            } else {
                alert('Usuário ou Senha inválido')
            }
        }).catch(e => alert('Erro ao efetuar o Login')); //alert.error('EXCEPTION: ', e))
}

(function($) {
    "use strict";

    /*==================================================================
    [ Validate ]*/
    var input = $('.validate-input .input100');

    $('.validate-form').on('submit', function() {
        var check = true;

        for (var i = 0; i < input.length; i++) {
            if (validate(input[i]) == false) {
                showValidate(input[i]);
                check = false;
            }
        }

        return check;
    });


    $('.validate-form .input100').each(function() {
        $(this).focus(function() {
            hideValidate(this);
        });
    });

    function validate(input) {
        if ($(input).attr('type') == 'email' || $(input).attr('name') == 'email') {
            if ($(input).val().trim().match(/^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{1,5}|[0-9]{1,3})(\]?)$/) == null) {
                return false;
            }
        } else {
            if ($(input).val().trim() == '') {
                return false;
            }
        }
    }

    function showValidate(input) {
        var thisAlert = $(input).parent();

        $(thisAlert).addClass('alert-validate');
    }

    function hideValidate(input) {
        var thisAlert = $(input).parent();

        $(thisAlert).removeClass('alert-validate');
    }



})(jQuery);