* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /produtos.
Resource         ../support/base.robot

* Keywords *

Obter Quantidade De Produtos
    [Documentation]    Retorna a quantidade de produtos cadastrados na API.

    ${response}        Enviar GET    /produtos

    ${quantidade}      Set Variable    ${response.json()["quantidade"]}

    [Return]           ${quantidade}

Preparar Produto Em Carrinho
    [Documentation]    Cria um produto presente em um carrinho e adiciona ao
    ...                registro de usuários.

    Preparar Novo Usuario Dinamico    user_carrinho    administrador=true
    ${token_auth}          Fazer Login                     ${registro_usuarios.user_carrinho}

    &{dados_produto}       Criar Dados Produto Dinamico
    ${id_produto}          Cadastrar Produto               ${dados_produto}    ${token_auth}

    ${id_carrinho}         Cadastrar Carrinho              ${id_produto}    ${token_auth}

    Set To Dictionary      ${registro_produtos}            produto_carrinho=${id_produto}


Limpar Produto Em Carrinho
    [Documentation]    Faz a limpeza dos dados preparados para a criação do
    ...                produto em carrinho.

    ${token_auth}      Fazer Login    ${registro_usuarios.user_carrinho}

    Cancelar Compra    ${token_auth}
    Limpar Registro De Produtos
    Limpar Registro De Usuarios


Validar Dados De Produto
    [Documentation]    Verifica se um produto existe, e se os dados equivalem ao esperado.
    [Arguments]        ${id_produto}    ${dados_esperados}
    
    ${response}                Enviar GET    /produtos/${id_produto}

    Validar Status Code        200    ${response}
    Validar Produto            ${response.json()}
    Validar Produtos Iguais    ${response.json()}    ${dados_esperados}


Validar Produto
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

    [Arguments]          ${produto_1}                  ${produto_2}
    Should Be Equal      ${produto_1["nome"]}          ${produto_2["nome"]}
    Should Be Equal      ${produto_1["preco"]}         ${produto_2["preco"]}
    Should Be Equal      ${produto_1["descricao"]}     ${produto_2["descricao"]}
    Should Be Equal      ${produto_1["quantidade"]}    ${produto_2["quantidade"]}

Validar Quantidade Produto
    [Documentation]      Verifica se a quantidade de produtos no estoque é a mesma que a
    ...                  esperada.

    [Arguments]                    ${esperado}    ${quantidade}
    Should Be Equal As Integers    ${esperado}    ${quantidade}