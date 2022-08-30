* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /usuarios.
Resource         ../support/base.robot


* Variables *
&{registro_usuarios}      # Dicionário que guarda as ids dos usuários cadastrados para limpeza de dados.
${id_produto}             # Id do produto cadastrado para criação de carrinho.

* Keywords *

Preparar Novo Usuario Estatico
    [Documentation]    Cria um usuário a partir de dados json e adiciona
    ...                ao dicionário de usuários.
    [Arguments]        ${chave}    ${dados_usuario}

    ${id_usuario}        Cadastrar Usuario    ${dados_usuario}
    Set To Dictionary    ${registro_usuarios}    ${chave}=${id_usuario}


Preparar Novo Usuario Dinamico
    [Documentation]    Cria um usuário a partir de dados dinâmicos e adiciona
    ...                ao dicionário de usuários.
    [Arguments]        ${chave}    ${administrador}=true

    &{dados_usuario}     Criar Dados Usuario Dinamico    ${administrador}  
    ${id_usuario}        Cadastrar Usuario               ${dados_usuario}

    Set To Dictionary    ${registro_usuarios}    ${chave}=${id_usuario}

Limpar Dicionario De Usuarios
    [Documentation]    Deleta todos os usuários presentes no dicionário de usuários.
    
    FOR  ${chave}    ${id_usuario}  IN  &{registro_usuarios}
        Deletar Usuario    ${id_usuario}
    END

    Set Suite Variable    &{registro_usuarios}    &{EMPTY}

Remover Usuario Do Dicionario
    [Documentation]    Remove um usuário do dicionário de usuários.
    ...                Utilizado para casos em que o usuário já foi deletado.
    [Arguments]        ${chave}

    Remove From Dictionary    ${registro_usuarios}    ${chave}

Preparar Usuario Com Carrinho
    [Documentation]    Cria um usuário com carrinho registrado e adiciona ao
    ...                dicionário de usuários.

    &{dados_usuario}       Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}          Cadastrar Usuario               ${dados_usuario}
    ${token_auth}          Fazer Login                     ${id_usuario}

    &{dados_produto}       Criar Dados Produto Dinamico
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}
    Set Suite Variable     ${id_produto}

    ${id_carrinho}         Cadastrar Carrinho              ${id_produto}    ${token_auth}

    Set To Dictionary      ${registro_usuarios}            user_carrinho=${id_usuario}


Limpar Usuario Com Carrinho
    [Documentation]    Faz a limpeza dos dados preparados para a criação do
    ...                usuário com carrinho.

    ${token_auth}      Fazer Login    ${registro_usuarios.user_carrinho}

    Cancelar Compra    ${token_auth}
    Deletar Produto    ${id_produto}    ${token_auth}

    Limpar Dicionario De Usuarios

Validar Criacao De Usuario
    [Documentation]    Verifica se um usuário foi realmente cadastrado, e se os
    ...                dados equivalem ao esperado.
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
