unit URouter.Produto;

interface

procedure RegistrarRotasProduto;

implementation

uses
  Horse,
  UController.Produto;

procedure RegistrarRotasProduto;
begin
  // Rota para buscar produto por codigo
  THorse.Get('/v1/produto/codigo/:codigo',
    UController.Produto.GetProdutoPorCodigo);

  // Rota para buscar por todos os produtos
  THorse.Get('/v1/produto', UController.Produto.GetProduto);

  // Rota para criar novo produto
  THorse.Post('/v1/produto', UController.Produto.CriarProduto);
end;

end.
