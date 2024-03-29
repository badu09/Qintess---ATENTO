//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
//Methods Included: ConsultarIndicacao, AtualizarStatusIndicacaoNovo
// Primary Port Class Name: CBSSIndicacoesSoap
public class WSIndicacoes {
    public class ArrayOfEErroCripto {
        public WSIndicacoes.EErroCripto[] EErroCripto;
        private String[] EErroCripto_type_info = new String[]{'EErroCripto','http://hml.webpartner.com.br','EErroCripto','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'EErroCripto'};
    }
    public class ArrayOfEIndicacaoRelCripto {
        public WSIndicacoes.EIndicacaoRelCripto[] EIndicacaoRelCripto;
        private String[] EIndicacaoRelCripto_type_info = new String[]{'EIndicacaoRelCripto','http://hml.webpartner.com.br','EIndicacaoRelCripto','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'EIndicacaoRelCripto'};
    }
    public class ArrayOfEProdutoCripto {
        public WSIndicacoes.EProdutoCripto[] EProdutoCripto;
        private String[] EProdutoCripto_type_info = new String[]{'EProdutoCripto','http://hml.webpartner.com.br','EProdutoCripto','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'EProdutoCripto'};
    }
    public class AtualizarStatusIndicacaoNovo_element {
        public String CodigoAcesso;
        public String Login;
        public String Senha;
        public String CodigoBanco;
        public String CodigoIndicacao;
        public String CodigoStatus;
        public String CodigoMotivo;
        public String XMLProdutoComercializado;
        public String DataVenda;
        private String[] CodigoAcesso_type_info = new String[]{'CodigoAcesso','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Login_type_info = new String[]{'Login','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Senha_type_info = new String[]{'Senha','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoBanco_type_info = new String[]{'CodigoBanco','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoIndicacao_type_info = new String[]{'CodigoIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoStatus_type_info = new String[]{'CodigoStatus','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoMotivo_type_info = new String[]{'CodigoMotivo','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] XMLProdutoComercializado_type_info = new String[]{'XMLProdutoComercializado','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] DataVenda_type_info = new String[]{'DataVenda','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'CodigoAcesso','Login','Senha','CodigoBanco','CodigoIndicacao','CodigoStatus','CodigoMotivo','XMLProdutoComercializado','DataVenda'};
    }
    public class AtualizarStatusIndicacaoNovoResponse_element {
        public WSIndicacoes.EResultCripto AtualizarStatusIndicacaoNovoResult;
        private String[] AtualizarStatusIndicacaoNovoResult_type_info = new String[]{'AtualizarStatusIndicacaoNovoResult','http://hml.webpartner.com.br','EResultCripto','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'AtualizarStatusIndicacaoNovoResult'};
    }

    // Unexpected WSDL node under definitions: {http://schemas.xmlsoap.org/wsdl/}documentation
  // WSDL node {http://schemas.xmlsoap.org/wsdl/}types expected before other nodes
    public class CBSSIndicacoesSoap {
        //public String endpoint_x = 'http://servico.webpartnergroup.com.br/Wscbssindicacoes/indicacoes2.asmx';
        //public String endpoint_x = 'http://hml.webpartner.com.br/webservice/wscbssindicacoes/indicacoes.asmx';
        //public String endpoint_x = 'http://hml.webpartner.com.br/webservice/wscbssindicacoes/indicacoes2.asmx';
        //public String endpoint_x = 'http://servico.webpartnergroup.com.br/wscbssindicacoes/indicacoes.asmx';
        //public String endpoint_x = 'http://servico.webpartnergroup.com.br/wscbssindicacoes/indicacoes2.asmx';
        //public String endpoint_x = 'http://hmlportalbancowebservice.grupoltm.com.br/Indicacoes2.asmx';
        //public String endpoint_x = 'http://servicohml.webpartnergroup.com.br/indicacoes2.asmx';
        public String endpoint_x = 'http://servico.webpartnergroup.com.br/wscbssindicacoes/indicacoes2.asmx';

        
        
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://hml.webpartner.com.br','WSIndicacoes'};

        public WSIndicacoes.EResultCripto AtualizarStatusIndicacaoNovo(String CodigoAcesso,String Login,String Senha,String CodigoBanco,String CodigoIndicacao,String CodigoStatus,String CodigoMotivo,String XMLProdutoComercializado,String DataVenda) {
            WSIndicacoes.AtualizarStatusIndicacaoNovo_element request_x = new WSIndicacoes.AtualizarStatusIndicacaoNovo_element();
            WSIndicacoes.AtualizarStatusIndicacaoNovoResponse_element response_x;
            request_x.CodigoAcesso = CodigoAcesso;
            request_x.Login = Login;
            request_x.Senha = Senha;
            request_x.CodigoBanco = CodigoBanco;
            request_x.CodigoIndicacao = CodigoIndicacao;
            request_x.CodigoStatus = CodigoStatus;
            request_x.CodigoMotivo = CodigoMotivo;
            request_x.XMLProdutoComercializado = XMLProdutoComercializado;
            request_x.DataVenda = DataVenda;
            Map<String, WSIndicacoes.AtualizarStatusIndicacaoNovoResponse_element> response_map_x = new Map<String, WSIndicacoes.AtualizarStatusIndicacaoNovoResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'http://hml.webpartner.com.br/AtualizarStatusIndicacaoNovo',
                'http://hml.webpartner.com.br',
                'AtualizarStatusIndicacaoNovo',
                'http://hml.webpartner.com.br',
                'AtualizarStatusIndicacaoNovoResponse',
                'WSIndicacoes.AtualizarStatusIndicacaoNovoResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.AtualizarStatusIndicacaoNovoResult;
        }

        public WSIndicacoes.EConsultarIndicacaoResultCripto ConsultarIndicacao(String CodigoAcesso,String Login,String Senha,String CodigoBanco,String XMLCodigoStatus) {
            WSIndicacoes.ConsultarIndicacao_element request_x = new WSIndicacoes.ConsultarIndicacao_element();
            WSIndicacoes.ConsultarIndicacaoResponse_element response_x;
            request_x.CodigoAcesso = CodigoAcesso;
            request_x.Login = Login;
            request_x.Senha = Senha;
            request_x.CodigoBanco = CodigoBanco;
            request_x.XMLCodigoStatus = XMLCodigoStatus;
            Map<String, WSIndicacoes.ConsultarIndicacaoResponse_element> response_map_x = new Map<String, WSIndicacoes.ConsultarIndicacaoResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                'http://hml.webpartner.com.br/ConsultarIndicacao',
                'http://hml.webpartner.com.br',
                'ConsultarIndicacao',
                'http://hml.webpartner.com.br',
                'ConsultarIndicacaoResponse',
                'WSIndicacoes.ConsultarIndicacaoResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.ConsultarIndicacaoResult;
        }
    }
    public class ConsultarIndicacao_element {
        public String CodigoAcesso;
        public String Login;
        public String Senha;
        public String CodigoBanco;
        public String XMLCodigoStatus;
        private String[] CodigoAcesso_type_info = new String[]{'CodigoAcesso','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Login_type_info = new String[]{'Login','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Senha_type_info = new String[]{'Senha','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoBanco_type_info = new String[]{'CodigoBanco','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] XMLCodigoStatus_type_info = new String[]{'XMLCodigoStatus','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'CodigoAcesso','Login','Senha','CodigoBanco','XMLCodigoStatus'};
    }
    public class ConsultarIndicacaoResponse_element {
        public WSIndicacoes.EConsultarIndicacaoResultCripto ConsultarIndicacaoResult;
        private String[] ConsultarIndicacaoResult_type_info = new String[]{'ConsultarIndicacaoResult','http://hml.webpartner.com.br','EConsultarIndicacaoResultCripto','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'ConsultarIndicacaoResult'};
    }
    public class EConsultarIndicacaoResultCripto {
        public String Codigo;
        public String Mensagem;
        public WSIndicacoes.ArrayOfEErroCripto Erro;
        private String[] Codigo_type_info = new String[]{'Codigo','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Mensagem_type_info = new String[]{'Mensagem','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Erro_type_info = new String[]{'Erro','http://hml.webpartner.com.br','ArrayOfEErroCripto','0','1','false'};
        
        public WSIndicacoes.ArrayOfEIndicacaoRelCripto EIndicacaoCripto;
        private String[] EIndicacaoCripto_type_info = new String[]{'EIndicacaoCripto','http://hml.webpartner.com.br','ArrayOfEIndicacaoRelCripto','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'Codigo','Mensagem','Erro','EIndicacaoCripto'};
    }
    public class EErroCripto {
        public String ErrCodigo;
        public String ErrMensagem;
        private String[] ErrCodigo_type_info = new String[]{'ErrCodigo','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] ErrMensagem_type_info = new String[]{'ErrMensagem','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'ErrCodigo','ErrMensagem'};
    }
    public class EIndicacaoRelCripto {
        public String CodigoBanco;
        public String RazaoSocialBanco;
        public String NomeFantasiaBanco;
        public String CodigoAgencia;
        public String NumeroAgencia;
        public String CodigoIndicacao;
        public String RazaoSocialIndicacao;
        public String CNPJIndicacao;
        public String NomeContatoIndicacao;
        public String NomeContato2Indicacao;
        public String DDDIndicacao;
        public String TelefoneIndicacao;
        public String DDD2Indicacao;
        public String Telefone2Indicacao;
        public String EmailIndicacao;
        public String QtdeFuncionariosIndicacao;
        public String DataCadastroIndicacao;
        public String CodigoUsuario;
        public String NomeUsuario;
        public String CodigoStatusAtual;
        public String StatusAtual;
        public String CodigoMotivoAtual;
        public String MotivoAtual;
        public String flagBackoffice;
        public String Observacao;
        public WSIndicacoes.ArrayOfEProdutoCripto Produto;
        private String[] CodigoBanco_type_info = new String[]{'CodigoBanco','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] RazaoSocialBanco_type_info = new String[]{'RazaoSocialBanco','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] NomeFantasiaBanco_type_info = new String[]{'NomeFantasiaBanco','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoAgencia_type_info = new String[]{'CodigoAgencia','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] NumeroAgencia_type_info = new String[]{'NumeroAgencia','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoIndicacao_type_info = new String[]{'CodigoIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] RazaoSocialIndicacao_type_info = new String[]{'RazaoSocialIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CNPJIndicacao_type_info = new String[]{'CNPJIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] NomeContatoIndicacao_type_info = new String[]{'NomeContatoIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] NomeContato2Indicacao_type_info = new String[]{'NomeContato2Indicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] DDDIndicacao_type_info = new String[]{'DDDIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] TelefoneIndicacao_type_info = new String[]{'TelefoneIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] DDD2Indicacao_type_info = new String[]{'DDD2Indicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Telefone2Indicacao_type_info = new String[]{'Telefone2Indicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] EmailIndicacao_type_info = new String[]{'EmailIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] QtdeFuncionariosIndicacao_type_info = new String[]{'QtdeFuncionariosIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] DataCadastroIndicacao_type_info = new String[]{'DataCadastroIndicacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoUsuario_type_info = new String[]{'CodigoUsuario','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] NomeUsuario_type_info = new String[]{'NomeUsuario','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoStatusAtual_type_info = new String[]{'CodigoStatusAtual','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] StatusAtual_type_info = new String[]{'StatusAtual','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] CodigoMotivoAtual_type_info = new String[]{'CodigoMotivoAtual','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] MotivoAtual_type_info = new String[]{'MotivoAtual','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Produto_type_info = new String[]{'Produto','http://hml.webpartner.com.br','ArrayOfEProdutoCripto','0','1','false'};
        private String[] flagBackoffice_type_info = new String[]{'flagBackoffice','http://hml.webpartner.com.br',null,'0','1','false'};
        private String[] Observacao_type_info = new String[]{'Observacao','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'CodigoBanco','RazaoSocialBanco','NomeFantasiaBanco','CodigoAgencia','NumeroAgencia','CodigoIndicacao','RazaoSocialIndicacao','CNPJIndicacao','NomeContatoIndicacao','NomeContato2Indicacao','DDDIndicacao','TelefoneIndicacao','DDD2Indicacao','Telefone2Indicacao','EmailIndicacao','QtdeFuncionariosIndicacao','DataCadastroIndicacao','CodigoUsuario','NomeUsuario','CodigoStatusAtual','StatusAtual','CodigoMotivoAtual','MotivoAtual','Produto','flagBackoffice','Observacao'};
    }
    public class EProdutoCripto {
        public String CodigoProduto;
        public String Produto;
        private String[] CodigoProduto_type_info = new String[]{'CodigoProduto','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Produto_type_info = new String[]{'Produto','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'CodigoProduto','Produto'};
    }
    public class EResultCripto {
        public String Codigo;
        public String Mensagem;
        public WSIndicacoes.ArrayOfEErroCripto Erro;
        private String[] Codigo_type_info = new String[]{'Codigo','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Mensagem_type_info = new String[]{'Mensagem','http://hml.webpartner.com.br','string','0','1','false'};
        private String[] Erro_type_info = new String[]{'Erro','http://hml.webpartner.com.br','ArrayOfEErroCripto','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://hml.webpartner.com.br','true','false'};
        private String[] field_order_type_info = new String[]{'Codigo','Mensagem','Erro'};
    }
}