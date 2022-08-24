* Settings *
Documentation    Arquivo contendo as keywords exclusivas para o Endpoint /carrinhos.
Resource         ../support/base.robot


* Keywords *

Validar Carrinho
    [Documentation]    Verifica se os dados de um carrinho correspondem ao esperado
    [Arguments]    ${carrinho}    @{lista_produtos}    
    ${len_lista}                    Get Length    ${lista_produtos}
    ${len_produtos}                 Get Length    ${carrinho["produtos"]}
    Should Be Equal As Integers     ${len_lista}    ${len_produtos}

    ${preco_total_lista}            Set Variable    ${0}
    ${quantidade_total_lista}       Set Variable    ${0}

    FOR  ${index}  IN RANGE    ${len_lista}
        ${produto_carrinho}             Set Variable    ${carrinho["produtos"][${index}]}
        ${produto_lista}                Set Variable    ${lista_produtos[${index}]}
        Should Be Equal                 ${produto_carrinho["idProduto"]}    ${produto_lista["idProduto"]}
        Should Be Equal As Integers     ${produto_carrinho["quantidade"]}    ${produto_lista["quantidade"]}

        ${response}            Enviar GET    /produtos/${produto_lista["idProduto"]}
        ${preco_produto}       Set Variable    ${response.json()["preco"]}
        Should Be Equal        ${produto_carrinho["precoUnitario"]}    ${preco_produto}

        ${preco_total_lista}          Evaluate    ${preco_total_lista}+(${${preco_produto}}*${${produto_lista["quantidade"]}})
        ${quantidade_total_lista}     Evaluate    ${quantidade_total_lista}+${${produto_lista["quantidade"]}}
    END

    Should Be Equal    ${carrinho["precoTotal"]}    ${preco_total_lista}
    Should Be Equal    ${carrinho["quantidadeTotal"]}    ${quantidade_total_lista}
    