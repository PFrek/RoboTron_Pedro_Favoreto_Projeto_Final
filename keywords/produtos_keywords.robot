* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /produtos.
Resource         ../support/base.robot


* Keywords *

Tentar Cadastrar Produto
    [Documentation]         Realiza uma tentativa de cadastro de produto com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário administrador para login, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de cadastro de usuário.
    ...                     \n\${id_usuario} -- a id do usuário criado para login.
    [Arguments]             ${json_produto}
    ##########
    # Setup
    ${dados_produto}        Set Variable    ${json["dados_cadastro"][${json_produto}]}

    &{dados_usuario}        Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}           Cadastrar Usuario               ${dados_usuario}
    ${token_auth}           Fazer Login                     ${id_usuario}
    &{headers}              Create Dictionary               Authorization=${token_auth}

    ##########
    # Teste
    ${response}             Enviar POST    /produtos    ${dados_produto}    headers=${headers}

    [Return]                ${response}    ${id_usuario}

Tentar Editar Produto Existente
    [Documentation]         Realiza uma tentativa de edição de produto existente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário administrador para login, e que precisa ser excluído manualmente.
    ...                     \nCria um produto que será editado, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de produto.
    ...                     \n\${id_usuario} -- a id do usuário criado para login.
    ...                     \n\${id_produto} -- a id do produto criado para edição.
    ...                     \n\${token_auth} -- a token de autorização do usuário logado.
    [Arguments]             ${json_edicao}
    ##########
    # Setup
    &{dados_usuario}        Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}           Cadastrar Usuario               ${dados_usuario}
    ${token_auth}           Fazer Login                     ${id_usuario}
    &{headers}              Create Dictionary               Authorization=${token_auth}

    &{dados_produto}        Criar Dados Produto Dinamico
    ${id_produto}           Cadastrar Produto               ${dados_produto}    ${token_auth}

    ${novos_dados}          Set Variable    ${json["dados_edicao"][${json_edicao}]}

    ##########
    # Teste
    ${response}             Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    [Return]                ${response}    ${id_usuario}    ${id_produto}    ${token_auth}

Tentar Editar Produto Inexistente
    [Documentation]         Realiza uma tentativa de edição de produto inexistente com os dados json informados.
    ...                     Não faz validações dentro da keyword.
    ...                     \nCria um usuário administrador para login, e que precisa ser excluído manualmente.
    ...                     \nReturn: \${response} -- a resposta da tentativa de edição de produto.
    ...                     \n\${id_usuario} -- a id do usuário criado para login.
    [Arguments]             ${json_edicao}
    ##########
    # Setup
    &{dados_usuario}        Criar Dados Usuario Dinamico    administrador=true
    ${id_usuario}           Cadastrar Usuario               ${dados_usuario}
    ${token_auth}           Fazer Login                     ${id_usuario}
    &{headers}              Create Dictionary               Authorization=${token_auth}

    ${id_produto}           Set Variable    naoexiste234

    ${novos_dados}          Set Variable    ${json["dados_edicao"][${json_edicao}]}

    ##########
    # Teste
    ${response}             Enviar PUT    /produtos/${id_produto}    ${novos_dados}    headers=${headers}

    [Return]                ${response}    ${id_usuario}

Validar Produto Valido
    [Documentation]      Verifica se o produto contém todos os campos exigidos pela ServeRest.
    [Arguments]          ${produto}
    Should Not Be Empty        ${produto["nome"]}
    Should Be True             ${produto["preco"]} >= 0
    Should Not Be Empty        ${produto["descricao"]}
    Should Be True             ${produto["quantidade"]} >= 0
    Should Not Be Empty        ${produto["_id"]}


Validar Produtos Iguais
    [Documentation]      Verifica se dois produtos serverest possuem todos os campos iguais.
    ...                  Ignora o campo de '_id'.

    [Arguments]          ${produto_1}    ${produto_2}
    Should Be Equal      ${produto_1["nome"]}    ${produto_2["nome"]}
    Should Be Equal      ${produto_1["preco"]}    ${produto_2["preco"]}
    Should Be Equal      ${produto_1["descricao"]}    ${produto_2["descricao"]}
    Should Be Equal      ${produto_1["quantidade"]}    ${produto_2["quantidade"]}

Validar Quantidade Produto
    [Documentation]      Verifica se a quantidade de produtos no estoque é a mesma que a
    ...                  esperada.

    [Arguments]                    ${esperado}    ${quantidade}
    Should Be Equal As Integers    ${esperado}    ${quantidade}