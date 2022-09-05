* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /usuarios.
Resource         ../support/base.robot


* Variables *
${produto_carrinho}             # Id do produto cadastrado para criação de carrinho.

* Keywords *

Obter Quantidade De Usuarios
    [Documentation]    Retorna a quantidade de usuários cadastrados na API.

    ${response}        Enviar GET    /usuarios

    ${quantidade}      Set Variable    ${response.json()["quantidade"]}

    [Return]           ${quantidade}

Preparar Usuario Com Carrinho
    [Documentation]    Cria um usuário com carrinho registrado e adiciona ao
    ...                registro de usuários.

    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}

    &{dados_produto}       Criar Dados Produto Dinamico
    ${produto_carrinho}    Cadastrar Produto               ${dados_produto}    ${token_auth}
    Set Suite Variable     ${produto_carrinho}

    ${id_carrinho}         Cadastrar Carrinho              ${produto_carrinho}    ${token_auth}

    Set To Dictionary      ${registro_usuarios}            user_carrinho=${id_usuario}


Limpar Usuario Com Carrinho
    [Documentation]    Faz a limpeza dos dados preparados para a criação do
    ...                usuário com carrinho.

    ${token_auth}      Fazer Login    ${registro_usuarios.user_carrinho}

    Cancelar Compra    ${token_auth}
    Deletar Produto    ${produto_carrinho}    ${token_auth}

    Limpar Registro De Usuarios

Validar Dados De Usuario
    [Documentation]    Verifica se um usuário existe, e se os dados equivalem ao esperado.
    [Arguments]        ${id_usuario}    ${dados_esperados}
    
    ${response}                Enviar GET    /usuarios/${id_usuario}

    Validar Status Code        200    ${response}
    Validar Usuario            ${response.json()}
    Validar Usuarios Iguais    ${response.json()}    ${dados_esperados}
    

Validar Usuario
    [Documentation]    Verifica se o usuario contém todos os campos exigidos pela ServeRest.
    [Arguments]        ${usuario}

    Should Not Be Empty        ${usuario["nome"]}
    Should Not Be Empty        ${usuario["email"]}
    Should Not Be Empty        ${usuario["password"]}
    Should Not Be Empty        ${usuario["administrador"]}
    Should Not Be Empty        ${usuario["_id"]}

Validar Usuarios Iguais
    [Documentation]    Verifica se dois usuários serverest possuem todos os campos iguais.
    ...                Ignora o campo de '_id'.
    [Arguments]        ${usuario_1}    ${usuario_2}

    Should Be Equal        ${usuario_1["nome"]}             ${usuario_2["nome"]}
    Should Be Equal        ${usuario_1["email"]}            ${usuario_2["email"]}
    Should Be Equal        ${usuario_1["password"]}         ${usuario_2["password"]}
    Should Be Equal        ${usuario_1["administrador"]}    ${usuario_2["administrador"]}
