/// Dados das telas de "recurso" (categorias). No Android original eram 10
/// Activities quase idênticas (activity_robotica, activity_gameterapia, ...
/// activity_tecnologia_movel, activity_tecnologia_assistiva), cada uma lendo
/// um texto resumo fixo no layout e um texto longo de @string/txt_* dentro
/// do "Saiba mais". Aqui isso vira 1 tela (ResourceScreen) + esta tabela.
class RecursoInfo {
  final String titulo;
  final String imagemAsset;
  final String descricaoResumo;
  final String textoSaibaMais; // conteúdo de strings.xml, com marcação <b>

  const RecursoInfo({
    required this.titulo,
    required this.imagemAsset,
    required this.descricaoResumo,
    required this.textoSaibaMais,
  });
}

final Map<String, RecursoInfo> recursosInfo = {
  'tecnologia_movel': const RecursoInfo(
    titulo: 'Tecnologia Móvel',
    imagemAsset: 'assets/images/tecnologia_movel.png',
    descricaoResumo:
        'Recursos de plataformas online e aplicativos para dispositivos móveis '
        '(smartphones ou tablets). Entre as funções destes recursos podemos '
        'citar a detecção de demandas em saúde, softwares de monitoramento '
        'clínico, auxiliares de autogerenciamento, educação em saúde, '
        'reabilitação e atividade física remota, reabilitação postural, '
        'rastreadores de sintomas e apoio de/adesão ao tratamento.',
    textoSaibaMais: _txtMovel,
  ),
  'tecnologia_assistiva': const RecursoInfo(
    titulo: 'Tecnologia Assistiva',
    imagemAsset: 'assets/images/tecnologia_assistiva.png',
    descricaoResumo:
        'Abrange recursos e dispositivos que auxiliam pessoas com perda de '
        'habilidade funcional, deficiências físicas e mentais na realização '
        'das atividades de vida diária. Exemplos desse tipo de recurso são '
        'adaptações de objetos para o dia-a-dia, órteses e próteses, '
        'dispositivos de apoio à mobilidade como cadeiras de rodas manuais '
        'ou motorizadas, bengalas e andadores, ajudas de transferência, e '
        'adaptações de acessibilidade.',
    textoSaibaMais: _txtAssistiva,
  ),
  'gameterapia': const RecursoInfo(
    titulo: 'Gameterapia',
    imagemAsset: 'assets/images/gameterapia.png',
    descricaoResumo:
        'A gameterapia envolve a aplicação de diversos recursos na reabilitação '
        'de incapacidades físicas e/ou cognitivas. Uma importante aplicação de '
        'jogos na reabilitação física são os "exergames", que são jogos que '
        'promovem exercícios físicos. Projetos de gameterapia podem abranger '
        'adaptações de controles e periféricos para jogos, captura de '
        'movimento, ambientes virtuais e até jogos completos.',
    textoSaibaMais: _txtGameterapia,
  ),
  'robotica': const RecursoInfo(
    titulo: 'Robótica',
    imagemAsset: 'assets/images/robotica.png',
    descricaoResumo:
        'A robótica de reabilitação abrange tecnologias essenciais para ajudar '
        'pessoas que sofrem de distúrbios do movimento a restaurar a atividade '
        'muscular normal com a possibilidade de resultados mensuráveis. Projetos '
        'de robótica podem incluir neuropróteses, cadeiras de rodas avançadas, '
        'exoesqueletos, treinadores robóticos de marcha, controladores de '
        'movimento, mobilizadores vestíveis e diversas outras aplicações.',
    textoSaibaMais: _txtRobotica,
  ),
  'realidade_virtual': const RecursoInfo(
    titulo: 'Realidade Virtual',
    imagemAsset: 'assets/images/realidade_virtual.png',
    descricaoResumo:
        'A Realidade Virtual (RV) abrange tecnologias para imersão em '
        'ambientes simulados digitalmente, com experiências interativas em 3D '
        'para aprendizado, lazer, treinamento de habilidades ou simulações que '
        'seriam inviáveis no mundo real. Os projetos de RV na reabilitação '
        'oferecem um ambiente imersivo e controlado para melhorar habilidades '
        'funcionais motoras e cognitivas em grupos específicos de pacientes.',
    textoSaibaMais: _txtVirtual,
  ),
  'recursos_avaliacao': const RecursoInfo(
    titulo: 'Recursos de Avaliação',
    imagemAsset: 'assets/images/recursos_avaliacao.png',
    descricaoResumo:
        'As tecnologias de avaliação e diagnóstico em Fisioterapia e '
        'reabilitação podem ter diversos objetivos como avaliar o risco de '
        'quedas em idosos, realizar análises biomecânicas do movimento, '
        'avaliar o alinhamento postural, monitorar a atividade física e o '
        'risco cardiovascular, e diversos outros. Recursos de avaliação podem '
        'incluir sensores inerciais, smartphones, câmeras de vídeo/profundidade, '
        'sensores de movimento ambiente, plataforma de detecção de pressão, '
        'monitores e sensores vestíveis, softwares de análise biomecânica, etc.',
    textoSaibaMais: _txtAvaliacao,
  ),
  'cinesioterapia': const RecursoInfo(
    titulo: 'Cinesioterapia',
    imagemAsset: 'assets/images/cinesioterapia.png',
    descricaoResumo:
        'Os recursos de cinesioterapia podem incluir dispositivos e '
        'equipamentos de exercícios terapêuticos para ganho de força, '
        'flexibilidade, mobilidade articular, equilíbrio e coordenação motora. '
        'Os recursos podem apresentar diversos níveis de complexidade, desde '
        'halteres/bastões até dispositivos de mobilização contínua e sistemas '
        'de biofeedback. Podem explorar desde equipamentos inovadores até '
        'programas de exercícios remotos mediados por Telessaúde.',
    textoSaibaMais: _txtCinesioterapia,
  ),
  'produto_educacional': const RecursoInfo(
    titulo: 'Produto Educacional',
    imagemAsset: 'assets/images/produto_educacional.png',
    descricaoResumo:
        'Processos ou produtos educacionais podem se referir ao ensino em '
        'Fisioterapia e reabilitação ou à educação em saúde direcionada a '
        'usuários em geral. Está diretamente relacionado ao espaço de '
        'aplicação, sendo o resultado de um processo de pesquisa e que deve '
        'ter um conjunto de características - aderência, impacto, '
        'aplicabilidade. Podem abranger, por exemplo, sequências didáticas, '
        'aplicativos, jogos, vídeos e vídeo-aulas, equipamentos, entre outros.',
    textoSaibaMais: _txtEducacional,
  ),
  'eletrotermoterapia': const RecursoInfo(
    titulo: 'Eletrotermoterapia',
    imagemAsset: 'assets/images/eletrotermoterapia.png',
    descricaoResumo:
        'Compreende recursos elétricos, térmicos e fototerapêuticos, incluindo '
        'tecnologias como eletroestimuladores, ultrassom terapêutico, '
        'dispositivos de crioterapia e termoterapia, além de equipamentos de '
        'fototerapia, como lasers e LEDs de alta intensidade. Destaca-se a '
        'reabilitação por meio da Estimulação Elétrica Funcional (FES), que é '
        'utilizada para ativar músculos fracos ou paralisados em condições '
        'neurológicas como AVC. Integrada a órteses, ela favorece a '
        'plasticidade neural e reduz a espasticidade, além de melhorar o '
        'controle motor.',
    textoSaibaMais: _txtEletro,
  ),
  'recursos_cardio': const RecursoInfo(
    titulo: 'Recursos Cardiorrespiratórios',
    imagemAsset: 'assets/images/cardiorespiratorios.png',
    descricaoResumo:
        'Englobam tecnologias voltadas ao monitoramento, avaliação e '
        'reabilitação de pacientes com condições cardíacas e pulmonares. '
        'Incluem ventiladores mecânicos em ambientes e também softwares de '
        'treinamento respiratório, promovendo adesão ao tratamento e '
        'permitindo supervisão remota. Monitores de atividade, como '
        'smartwatches com sensores de frequência cardíaca, saturação de '
        'oxigênio, e padrões de respiração, fornecendo dados em tempo real '
        'para avaliar o desempenho físico e detectar anormalidades. Já os '
        'dispositivos vestíveis avançados podem incorporar tecnologia de '
        'biofeedback e de monitoração clínica.',
    textoSaibaMais: _txtCardio,
  ),
};

/// Mapa categoria (como salva no Firebase) -> chave do recurso (rota).
const Map<String, String> categoriaParaRecursoKey = {
  'Tecnologia móvel': 'tecnologia_movel',
  'Tecnologia assistiva': 'tecnologia_assistiva',
  'Gameterapia': 'gameterapia',
  'Realidade virtual': 'realidade_virtual',
  'Robótica': 'robotica',
  'Recursos de avaliação': 'recursos_avaliacao',
  'Cinesioterapia': 'cinesioterapia',
  'Produto educacional': 'produto_educacional',
  'Eletrotermoterapia': 'eletrotermoterapia',
  'Recursos cardiorespiratório': 'recursos_cardio',
};

const String _txtMovel = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
O foco do projeto na interface e na interação do usuário com o sistema, buscando identificar o problema principal que motivou o projeto, a fim de definir os objetivos do recurso proposto.
<b>Pesquisa e Análise de dados</b>
Pesquisa de similares na literatura, no mercado e em bases de registro (Google play, INPI, etc.). Pesquisar referências teóricas para definição do conteúdo da tecnologia. Explorar possibilidades técnicas como a linguagem de programação e os modos de interatividade e tipos de mídias utilizadas. Pesquisar leis e normas técnicas como a LGPD.
<b>Conceito e Criação</b>
Na geração de conceitos e ideias de solução, dar ênfase aos aspectos estéticos e de interatividade na interface com o usuário, por meio de recursos como pesquisa de imagens e mapas conceituais. As ideias referentes a cores e diagramação devem ser analisadas.
<b>Especificações técnicas</b>
Definição e detalhamento dos recursos e tecnologias do produto. Softwares baseados na web funcionam como aplicativos com acesso por navegador web, Aplicativos móveis, são instalados no dispositivo, podendo oferecer funções offline. Detalhar funções oferecidas, compatibilidade e limitações com sistemas operacionais e dispositivos.
<b>Protótipo e avaliação</b>
Construção de protótipos ou modelos de testes. Realizar testes de funcionalidade nas diversas plataformas, testes de usabilidade e de estabilidade nos dispositivos (smartfones, tablets, PCs, etc.). Realizar os ajustes e adequações requeridas de acordo com os testes.
<b>Produto</b>
Após ajustes e aprimoramentos do protótipo, seguir o desenvolvimento do modelo finalizado da aplicação móvel com vistas à utilização pelo público-alvo e no alcance do objetivo. Nesta etapa podem surgir novas demandas de melhorias visando melhorias do recurso.
<b>Registro e Patente</b>
Produtos digitais como plataformas online e aplicativos móveis podem ser registrados no INPI (Apps e softwares) ou na plataforma de registro de domínios de internet no Brasil (aplicações baseadas na web).
''';

const String _txtAssistiva = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
O foco do projeto no usuário do produto e na sua funcionalidade, buscando identificar o problema principal e objetivos do produto proposto.
<b>Pesquisa e Análise de dados</b>
Pesquisa de similares na literatura científica, no mercado e em bases de patentes (Bases de dados, INPI, etc.). Pesquisar leis e normas técnicas que possam influenciar o projeto (Lei da acessibilidade, NBRs, etc.). Estudar conceitos e variáveis ergonômicas (tabelas antropométricas, etc.). Explorar possibilidades de materiais e recursos técnicos. Coletar dados do usuário (antropometria, funcionalidade, qualidade de vida, etc.).
<b>Conceito e Criação</b>
Utilizar ferramentas de criatividade para definir requisitos e alternativas de solução para o projeto, como as técnicas de brainstorm e a matriz de alternativas. Nesta etapa, é importante explorar as possibilidades estéticas do produto.
<b>Especificações técnicas</b>
Definir e detalhar recursos e tecnologias incorporadas ao projeto; descrição das características do produto como materiais, dimensões, componentes, ergonomia, funcionalidade, usabilidade, segurança e atributos estéticos (cores, formas, texturas, etc.). Gerar desenhos técnicos detalhados e tabelas de componentes e materiais.
<b>Protótipo e avaliação</b>
Construção de modelos digitais, e/ou protótipos de baixa ou alta fidelidade para avaliação de atributos e execução de testes funcionais, ergonômicos, de segurança e usabilidade. De acordo com o produto, podem ser usadas diversas técnicas e materiais, como a impressão 3d, e a modelagem digital.
<b>Produto</b>
Após ajustes e melhorias no protótipo, seguir a construção de um modelo totalmente funcional do produto para testes em contexto real com usuários. Devem ser usados os materiais e especificações finais do produto. Nesta etapa podem surgir novas demandas de melhorias para a definição do produto final.
<b>Registro e Patente</b>
Produtos tangíveis ou tridimensionais como a maioria dos recursos de Tecnologia Assistiva podem ser objeto de pedido de patente, no INPI, o que dependerá de fatores como a originalidade do invento e a sua aplicação industrial.
''';

const String _txtRobotica = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
Definir o problema principal e os objetivos do projeto com foco na funcionalidade do usuário destinatário e no tipo de tecnologia robótica a ser empregada com o objetivo de melhorar a capacidade funcional do indivíduo.
<b>Pesquisa e Análise de dados</b>
A pesquisa de similares pode ser realizada, no mercado nacional e internacional, e em bases de patentes (INPI, Google patentes, WIPO, etc.). Pesquisar recursos tecnológicos como componentes mecânicos e digitais. Estudar os modos de interface com o usuário como dispositivos vestíveis, operacionais ou mistos. Calcular os custos envolvidos no projeto.
<b>Conceito e Criação</b>
Utilizar ferramentas de criatividade para definir requisitos e alternativas de solução para o projeto. Pode-se empregar as técnicas de brainstorm e a matriz de alternativas dentre outras. Devido à complexidade dos projetos de robótica, pode ser necessário combinar duas ou mais técnicas.
<b>Especificações técnicas</b>
Detalhar e descrever atributos do produto como materiais (ligas metálicas, compósitos, polímeros, etc.), dimensões, componentes (placas de controle, servo-motores, atuadores mecânicos, softwares e drivers, etc.), ergonomia, tipo de interface (vestível, operacional ou misto), funcionalidade e usabilidade. Construir desenhos técnicos detalhados e tabelas de componentes.
<b>Protótipo e avaliação</b>
Construção de modelos digitais e/ou protótipos físicos de baixa ou alta fidelidade para avaliação de atributos e execução de testes funcionais, ergonômicos, de segurança e usabilidade. De acordo com as especificações do produto, podem ser usadas diversas técnicas e materiais, como a modelagem digital a impressão 3d, a usinagem, fundição etc.
<b>Produto</b>
Construção de um modelo totalmente funcional do produto para ser testado em situação real de com usuários. Devem ser usados os materiais e especificações finais do produto. Nesta etapa podem surgir novas demandas de melhorias visando uma versão finalizada do produto de robótica.
<b>Registro e Patente</b>
Produtos de robótica podem ser objeto de pedido de patente no INPI, o que dependerá de fatores como a originalidade do invento e a sua aplicação industrial. Em caso de desenvolvimento de softwares ou drivers de controle relacionados, estes também podem ser objetos de registro.
''';

const String _txtGameterapia = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
O foco do projeto de gameterapia deve estar na interação esperada entre o usuário e o sistema do jogo, levando em consideração as características do jogador, os recursos tecnológicos empregados e o objetivo terapêutico da atividade.
<b>Pesquisa e Análise de dados</b>
Realizar pesquisa de similares na literatura científica, no mercado e em bases de registro (Google play, Microsoft Store, Nintendo.com, INPI, etc.). Pesquisar recursos tecnológicos envolvidos como de acordo com o objetivo terapêutico, como plataforma de sistema e recursos de interação e controle (joysticks, sensores de movimento, etc.). Coletar dados do usuário (antropometria, funcionalidade, qualidade de vida, etc.).
<b>Conceito e Criação</b>
Utilizar ferramentas de criatividade para definir requisitos e alternativas de solução para o projeto. Em projetos de terapia por jogos podem ser úteis técnicas como o brainstorm, a pesquisa de imagens e os mapas conceituais, a fim de explorar e selecionar ideias por meio de conceitos e referências visuais.
<b>Especificações técnicas</b>
Definição dos recursos materiais e tecnologias incorporados ao projeto; descrição de atributos como materiais, dimensões, componentes, ergonomia, funcionalidade, usabilidade e estética (cores, formas, texturas, etc.). Descrever as funções de acordo com tipo de tecnologia e plataforma adotada (Microsoft Kinect, Nintendo Wii, Android, Windows, etc.). Podem ser gerados desenhos técnicos detalhados e tabelas de componentes e materiais, ou detalhamento de códigos digitais.
<b>Protótipo e avaliação</b>
Construção de protótipos de dispositivos físicos ou versões de testes para as aplicações digitais. As técnicas e materiais usadas para a confecção do protótipo dependerão das especificações do produto. Realizar testes de funcionalidade, de usabilidade e de estabilidade em dispositivos (consoles, smartphones, tablets, PCs, etc,). Realizar ajustes e adequações requeridas.
<b>Produto</b>
Os aprimoramentos realizados na etapa de protótipo, devem guiar a construção de um modelo funcional do produto a ser testado em situação e contexto real com usuários. Devem ser usados os materiais e especificações finais do produto, podendo surgir novas demandas de melhorias visando a definição de uma versão final do recurso.
<b>Registro e Patente</b>
Produtos tangíveis ou físicos como periféricos para jogos podem ser objeto de pedido de patente, no INPI, o que dependerá de fatores como originalidade do invento e a sua aplicação industrial. Em caso de desenvolvimento de recursos digitais, estes também podem ser objetos de registro.
''';

const String _txtAvaliacao = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
Definir o problema principal e os objetivos, com foco nas variáveis e dimensões funcionais que se espera avaliar ou medir, levando em consideração as características individuais, e o nível de complexidade do projeto.
<b>Pesquisa e Análise de dados</b>
A pesquisa de similares deve focar na literatura científica, no mercado e em bases de registro (BVS, INPI, etc.). Analisar os recursos tecnológicos de acordo com as variáveis-alvo, como sensores de monitoramento remoto, monitores vestíveis, acelerômetros, câmeras digitais, plataformas de força, softwares de análise de imagem, etc. Se necessário, coletar dados com o público-alvo do produto.
<b>Conceito e Criação</b>
Utilizar ferramentas de criatividade para definir requisitos e alternativas de solução para o projeto. Pode-se empregar técnicas como o brainstorm e a matriz de alternativas, dentre outras. Considerando a relação custo-acurácia em recursos de avaliação, a matriz de alternativas pode ser a ferramenta mais indicada.
<b>Especificações técnicas</b>
Detalhamento dos atributos e características do produto, como recursos tecnológicos, materiais, dimensões, ergonomia, componentes eletrônicos, princípios de funcionamento, tipo de medição, variáveis medidas, e padrões de comparação. Nesta etapa são gerados desenhos técnicos detalhados e tabelas de componentes.
<b>Protótipo e avaliação</b>
Construção de modelos digitais e/ou protótipos físicos de alta fidelidade para testes de acurácia (fidelidade da medição em relação a um padrão de referência) e avaliação de atributos como ergonomia, segurança e usabilidade para detecção de falhas no projeto e aprimoramentos. As técnicas e materiais usados no protótipo dependerão das especificações do produto.
<b>Produto</b>
Após ajustes e melhorias no protótipo, deve-se seguir a construção de um modelo totalmente funcional do produto para ser testado em contexto real com usuários. Devem ser usados os materiais e especificações finais do produto, sempre buscando melhorar a eficiência do recurso de avaliação.
<b>Registro e Patente</b>
Produtos tangíveis ou físicos como os dispositivos de avaliação física podem ser objeto de pedido de patente, no INPI, o que dependerá de fatores como originalidade do invento e a sua aplicação industrial.
''';

const String _txtEducacional = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
A definição do problema deve focar no ambiente de aplicação do projeto e no público-alvo, buscando identificar as demandas e definir os objetivos do processo de ensino-aprendizagem.
<b>Pesquisa e Análise de dados</b>
Realizar pesquisa na literatura científica e em bases de registro educacionais (BVS, Pubmed, repositórios institucionais, Educapes, etc.). Realizar estudos de revisão, estudos descritivos e/ou exploratórios para definição das bases conceituais do projeto. Explorar possibilidades tecnológicas para o produto de acordo com o nível de complexidade. Se necessário, realizar estudos situacionais com o público-alvo para identificação de necessidades.
<b>Conceito e Criação</b>
O processo de elaboração de alternativas de soluções dependerá dos objetivos pedagógicos do projeto, levando em consideração as bases conceituais adotadas. Para produtos educacionais podem ser útil a pesquisa de imagens com base nos conceitos do projeto, e os mapas conceituais.
<b>Especificações técnicas</b>
Detalhamento da ideia de solução adotada, dos atributos e características do produto. Descrição do tipo de produto educacional. Detalhar os requisitos técnicos (meio de apresentação, plataformas compatíveis, materiais, dimensões, ergonomia, modos de funcionamento, etc.), assim como, os requisitos estéticos como estilos, cores, formas, etc.
<b>Protótipo e avaliação</b>
Construção de protótipos ou versões preliminares do produto para execução de testes e avaliações. Para produtos educacionais os testes de usabilidade são os mais utilizados, e o processo de avaliação, neste caso, é chamado de validação, que pode ser direcionada a diferentes aspectos do produto, como a validação pedagógica e a validação semântica.
<b>Produto</b>
Após as melhorias na etapa de testes e validação do protótipo, deve-se construir um modelo finalizado do produto para ser aplicado em situação e contexto real com o público-alvo. Devem ser usados as especificações finais do produto, sempre buscando aperfeiçoá-lo no alcance dos objetivos de ensino-aprendizagem.
<b>Registro e Patente</b>
Produtos de base literária (ebook, manuais, roteiros, etc.) podem ser registrados na Biblioteca Nacional (ISBN); recursos audiovisuais (vídeos, animações, etc.) são registrados na ANCINE. Produtos de base física como simuladores podem obter registro de patente no INPI. O portal Educapes é um repositório de produtos educacionais que abrange diversos tipos de recursos como livros, vídeos, sites, aplicativos, etc.
''';

const String _txtVirtual = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
Definir o problema principal com foco no público-alvo e nos objetivos esperados. Abordar a necessidade de criar um ambiente virtual que simule situações e experiências específicas, como na recuperação funcional ou adaptação a novas condições.
<b>Pesquisa e Análise de dados</b>
Pesquisar sistemas similares na literatura científica, mercado e bases de registro (Google Play, Steam, INPI, etc.). Analisar hardwares e softwares como headsets de RV (ex.: Apple Vision, Oculus Quest, HTC Vive) e controladores/sensores de movimento. Explorar conceitos relacionados ao projeto, como pedagogia, ergonomia, psicologia ou design de jogos, tal como dados dos usuários, como habilidades motoras, limitações e preferências. Considerar aspectos como acessibilidade, privacidade (ex.: LGPD) e segurança no uso de dispositivos de RV.
<b>Conceito e Criação</b>
Nesta etapa, utiliza-se ferramentas de criatividade, como brainstorm, referências visuais, mapas conceituais e moodboards, para gerar ideias para o ambiente virtual, considerando aspectos visuais, interatividade e feedback. Ajustar os conceitos ao público específico (educadores, profissionais da saúde, gamers, etc.).
<b>Especificações técnicas</b>
Definir os requisitos de hardware (headsets, sensores de movimento, controladores, plataformas de esteira) e software (motores gráficos e drivers) do projeto. Especificar os cenários virtuais, tipo de interação e navegação, detalhamento do cenário 3D, interação com objetos, animações, e feedbacks sensoriais. Identificar as plataformas suportadas e os requisitos do projeto (Windows, Android, consoles, etc.).
<b>Protótipo e avaliação</b>
Desenvolver uma versão inicial para testar funcionalidades e avaliar aspectos como imersão, usabilidade, estabilidade, interface e impacto do sistema para os usuários. Realizar avaliações e ajustes para corrigir falhas, indicar melhorias no design e no desempenho técnico.
<b>Produto</b>
Com base nos ajustes realizados, desenvolver a versão final do produto. Nesta etapa, o produto deve estar pronto para ser utilizado em contexto real, considerando o público-alvo e o objetivo final. Continuar aperfeiçoando a aplicação com base nos feedbacks dos usuários.
<b>Registro e Patente</b>
Sistemas de RV podem ser registrados como software (registro de programas no INPI), hardware (registro de patente no INPI) e produtos audiovisuais e interativos (registro animações, vídeos, ambientes 3D, em órgãos como a ANCINE), dependendo da originalidade e da aplicação industrial.
''';

const String _txtCinesioterapia = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
O projeto deve focar no impacto do movimento na saúde do indivíduo, identificando as demandas funcionais do público-alvo e definir os objetivos terapêuticos, como reabilitação de movimentos específicos ou melhoria da qualidade de vida.
<b>Pesquisa e Análise de dados</b>
Realizar revisão da literatura científica (Pubmed, BVS, Scielo, etc.) e consulta a protocolos clínicos padronizados para definir as bases do projeto. Explorar recursos já existentes, como equipamentos de mobilização, análise biomecânica e exercícios guiados por tecnologias, a fim de identificar lacunas e necessidades. Coletar dados específicos do público-alvo, como limitações funcionais e metas terapêuticas.
<b>Conceito e Criação</b>
Desenvolver alternativas e soluções com base nos objetivos terapêuticos definidos. Técnicas como brainstorm e mapas conceituais podem auxiliar na criação de programas terapêuticos ou equipamentos inovadores.
<b>Especificações técnicas</b>
Detalhar os requisitos do produto, como ergonomia, dimensões, materiais, tipo de resistência, ajustes de carga e funcionalidade. Para recursos digitais, especificar tipos de exercícios, interatividade e feedback para o usuário. Busca-se apresentar esquemas detalhados e componentes do projeto. Atenção especial aos requisitos de segurança dos recursos.
<b>Protótipo e avaliação</b>
Construir modelos funcionais de dispositivos, equipamentos ou sistemas para execução de testes. Avaliar segurança, conforto, eficácia, ergonomia e impacto terapêutico. De acordo com os resultados obtidos, ajustar e aprimorar o produto. Os processos de construção dependerão dos tipos de recurso, podendo incluir a impressão 3D e a modelagem de compósitos.
<b>Produto</b>
Após os ajustes no protótipo, desenvolver o modelo final do produto de acordo com as especificações técnicas, pronto para aplicação clínica do produto para avaliar a eficácia terapêutica. Sempre buscar melhorias contínuas para atender às demandas terapêuticas.
<b>Registro e Patente</b>
Equipamentos ou dispositivos inovadores de cinesioterapia podem ser patenteados no INPI. Protocolos clínicos podem ser registrados em repositórios especializados ou instituições de ensino com repositório próprio.
''';

const String _txtEletro = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
O foco do projeto deve estar na eficácia do tratamento proposto, e na abordagem biofísica da tecnologia, considerando a condição do paciente e os objetivos terapêuticos, como alívio de dor, redução de edema ou melhora funcional.
<b>Pesquisa e Análise de dados</b>
Revisar a literatura científica sobre recursos tecnológicos previstos e protocolos clínicos em bases de dados (PEDro, SciELO, BVS, LILACS, PubMed, Cochrane, Medline, etc.), usando descritores registrados no DeCS/MeSH. Pesquisar recursos similares no mercado, como dispositivos eletroterapêuticos e de aquecimento/refrigeração (banco de dados e patentes do INPI, WIPO e Copyright).
<b>Conceito e Criação</b>
O intuito é criar alternativas de solução com base nos objetivos terapêuticos. Para tanto, é interessante elencar quais requisitos e limitações da criação, o que pode ser feito com ferramentas de criatividade como os mapas conceituais e a matriz de alternativas para explorar novas abordagens, coma portabilidade e interatividade.
<b>Especificações técnicas</b>
Detalhar os requisitos do produto, como a modalidade biofísica (correntes elétricas, campos magnéticos, irradiação, ondas acústicas, trocas térmicas, etc.); e as especificações do recurso (intensidade de corrente, frequências, potência, temperaturas, segurança e usabilidade). Para equipamentos e dispositivos, incluir dimensões, materiais, componentes e funcionalidades.
<b>Protótipo e avaliação</b>
Construir protótipos funcionais para avaliação de desempenho, segurança e eficácia terapêutica. Realizar testes e medições técnicas em laboratório e ajustar com base nos resultados. Pode ser necessário realizar pesquisas de aplicação clínica do protótipo.
<b>Produto</b>
Desenvolver o modelo final do recurso após os ajustes no protótipo, garantindo segurança e eficácia no uso clínico. Nesta etapa é indispensável a pesquisa de aplicação clínica do produto para avaliar a eficácia terapêutica antes do registro e da comercialização.
<b>Registro e Patente</b>
Equipamentos e dispositivos podem ser patenteados no INPI, dependendo da inovação e aplicação industrial. Recursos baseados em circuitos eletrônicos podem ser registrados no INPI como topografia de circuitos integrados.
''';

const String _txtCardio = '''
<b>Etapas do Projeto</b>
<b>Problema e objetivos</b>
Definir o problema com foco nas condições clínicas específicas do público-alvo, como insuficiência cardíaca, DPOC ou asma, e nos objetivos terapêuticos, incluindo a melhora da capacidade funcional, controle da dispneia, e função cardiorrespiratória.
<b>Pesquisa e Análise de dados</b>
Realizar revisão da literatura científica (PubMed, Scielo, Cochrane) e análise de dispositivos existentes no mercado e em patentes registradas (INPI, WIPO). Avaliar as demandas do público-alvo, coletando dados sobre limitações funcionais, qualidade de vida, adesão terapêutica e necessidades específicas.
<b>Conceito e Criação</b>
Gerar soluções inovadoras e práticas para melhorar a reabilitação e o monitoramento cardiorrespiratório. Brainstorming e mapas conceituais podem ajudar na concepção de ideias como sensores vestíveis integrados ou aplicativos que forneçam feedback personalizado baseado em dados coletados.
<b>Especificações técnicas</b>
Detalhar os atributos do produto, como interfaces, usabilidade e portabilidade. Definir os parâmetros monitorados, como frequência cardíaca, ventilação e oxigenação, usabilidade, portabilidade e integração com plataformas digitais. Especificar a tecnologia de transmissão de dados (Bluetooth, Wi-Fi), compatibilidade com sistemas móveis e segurança cibernética para proteção dos dados do usuário.
<b>Protótipo e avaliação</b>
Construir protótipos funcionais para testes em laboratório e contextos clínicos simulados. Avaliar a precisão dos dados coletados, impacto no tratamento e a usabilidade para pacientes e profissionais. Ajustar o design com base nos resultados para garantir eficácia.
<b>Produto</b>
Desenvolver o modelo final, pronto para aplicação clínica e domiciliar. Certificar que o produto atende a padrões de segurança, eficácia e usabilidade, incorporando melhorias contínuas baseadas no feedback dos usuários.
<b>Registro e Patente</b>
Dispositivos inovadores podem ser registrados como patente no INPI e regulamentados pelo órgão fiscalizador Anvisa, considerando as exigências legais para equipamentos médicos e softwares.
''';
