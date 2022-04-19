function verificaCampos() {

    var nome = window.document.getElementById("inputNome").value;
    var celular = window.document.getElementById("inputCelular").value;
    var email = window.document.getElementById("inputEmail").value;


    if (nome.length == 0) {
        exibeMensagem("Nome");
        return;
    } else if (celular.length == 0) {
        exibeMensagem("Celular");
        return;
    } else if (email.length == 0 || !email.includes("@")) {
        exibeMensagem("Email");
        return;
    } else {
        enviaFormulario();
        return;

    }


}

function exibeMensagem(campo) {
    bootbox.alert("Preencha o campo " + campo);
}

function enviaFormulario() {
    bootbox.alert("Mensagem enviada!");
    window.document.getElementById("inputNome").value = '';
    window.document.getElementById("inputCelular").value = '';
    window.document.getElementById("inputEmail").value = '';


}

function mascara() {
    var valor = document.getElementById("inputCelular").value;
    document.getElementById("inputCelular").value = executaMascara(valor);
}

function executaMascara(v) {
    v = v.replace(/\D/g, ""); //Remove tudo o que não é dígito numérico
    v = v.replace(/^(\d{2})(\d)/g, "($1) $2"); //Coloca parênteses do DDD
    v = v.replace(/(\d)(\d{4})$/, "$1-$2"); //Coloca hífen -
    return v;
}
//	asas