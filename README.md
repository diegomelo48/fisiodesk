# FisioDesk — Migração completa Android (Java + Firebase) → Flutter

Esta é a migração **completa** do app FisioDesk: todas as Activities, Fragments,
Adapters, Models e Dialogs originais foram recriados em Flutter, com integração
real ao mesmo projeto Firebase (`natasha-ec058`) usado no app Android.

## 1. Configurar o Firebase

Você tem duas opções:

### Opção A — usar o que já vem pronto (mais rápido)
- `lib/firebase_options.dart` já contém as credenciais Android extraídas do
  `google-services.json` que você enviou (apiKey, appId, projectId, databaseURL,
  storageBucket). Isso é o suficiente para inicializar o Firebase no Android
  **sem precisar do plugin Gradle `google-services`**, porque estamos passando
  as opções explicitamente em `Firebase.initializeApp(options: ...)`.
- O `google-services.json` original também foi copiado para
  `android/app/google-services.json` (só terá efeito se você aplicar o plugin
  Gradle — ver Opção B).
- **Isso só cobre Android.** Se o app também vai rodar em iOS/Web, você
  **precisa** rodar `flutterfire configure` (Opção B) para gerar as opções
  dessas plataformas.

### Opção B — regenerar via FlutterFire CLI (recomendado a médio prazo)
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=natasha-ec058
```
Isso substitui `lib/firebase_options.dart` automaticamente e configura
Android/iOS/Web corretamente, incluindo o plugin Gradle no Android.

## 2. Como rodar

Este pacote contém apenas `lib/`, `pubspec.yaml` e um `android/app/google-services.json`
de referência — **não é um projeto Flutter completo** (sem as pastas nativas
`android/` e `ios/` geradas por `flutter create`). Para rodar:

```bash
flutter create --org devdiego.julio --project-name fisiodesk .
# (isso gera android/, ios/, etc. sem sobrescrever lib/ e pubspec.yaml existentes
#  — confirme os prompts de sobrescrita apenas para os arquivos de plataforma)
flutter pub get
flutter run
```

Depois disso, garanta que o `applicationId` em `android/app/build.gradle` seja
`devdiego.julio.fisiodesk` (mesmo pacote do `google-services.json`), ou o
Firebase vai rejeitar a conexão.

## 3. Assets que faltam adicionar

O app referencia estas imagens em `assets/images/` (troque pelos originais do
projeto Android — todos têm um ícone de fallback caso o arquivo não exista,
então o app **não quebra** sem eles, só mostra um placeholder):

```
bg.png, tecnologia_movel.png, tecnologia_assistiva.png, gameterapia.png,
robotica.png, realidade_virtual.png, recursos_avaliacao.png, cinesioterapia.png,
eletrotermoterapia.png, produto_educacional.png, cardiorespiratorios.png,
problema_objetivos.png, pesquisa_dados.png, conceito_criacao.png,
especificacoes_tecnicas.png, prototipo_avaliacao.png, produto.png,
registro_patente.png, img_metodos.png, img_painel.png, img_artigos.png,
bg_guias.png
```

E em `assets/pdf/` (⚠️ **estes não têm fallback** — o visualizador de PDF vai
dar erro em tempo de execução se os arquivos não existirem):
```
assets/pdf/Guia-FisioDesk.pdf                  (era "Guia-FisioDesk.pdf")
assets/pdf/Guia-aplicacao-pedagogica.pdf       (era "Guia-aplicação-pedagogica.pdf",
                                                 renomeado sem acento por segurança)
```
O PDF de "Métodos" continua sendo baixado de uma URL do Google Drive (mesma URL
do `MetodosActivity` original), então não precisa de arquivo local.

## 4. Mapeamento completo Android → Flutter

| Original (Java/XML) | Flutter |
|---|---|
| SplashActivity | `screens/splash_screen.dart` |
| LoginActivity | `screens/login_screen.dart` |
| CadastroActivity | `screens/cadastro_screen.dart` |
| RecuperarSenhaActivity | `screens/recuperar_senha_screen.dart` |
| MainActivity + nav_header + drawer_menu + bottom_nav_menu | `screens/main_screen.dart` |
| HomeFragment | `screens/home_tab.dart` |
| CategoriasFragment | `screens/categorias_tab.dart` |
| ProjetosEtapasFragment | `screens/projetos_etapas_tab.dart` |
| GuiasFragment | `screens/guias_tab.dart` |
| EquipeFragment + dialog_add_equipe | `screens/equipe_tab.dart` + `dialogs/add_equipe_dialog.dart` |
| PerfilFragment + dialog_editar_perfil | `screens/perfil_screen.dart` + `dialogs/editar_perfil_dialog.dart` |
| SobreFragment | `screens/sobre_screen.dart` |
| AutoresFragment | `screens/autores_screen.dart` |
| LinksFragment | `screens/links_screen.dart` |
| ArtigosActivity | `screens/artigos_screen.dart` |
| GuiaAppActivity / GuiaAplicacaoActivity / MetodosActivity | `screens/pdf_viewer_screen.dart` (genérica) |
| NovoProjetoActivity | `screens/novo_projeto_screen.dart` |
| NovaEtapaActivity | `screens/nova_etapa_screen.dart` |
| EtapasActivity + dialog_add_responsavel | `screens/etapa_detalhe_screen.dart` + `dialogs/add_responsavel_dialog.dart` |
| DetalhesProjetoEtapaActivity + layout_editar_projeto | `screens/detalhes_projeto_screen.dart` + `dialogs/editar_projeto_dialog.dart` |
| RoboticaActivity, GameterapiaActivity, CinesioterapiaActivity, EletrotermoterapiaActivity, ProdutoEducacionalActivity, RealidadeVirtualActivity, RecursosAvaliacaoActivity, RecursosCardioActivity, TecnologiaAssistivaActivity, TecnologiaMovelActivity | **1 tela só**: `screens/resource_screen.dart` + `models/recurso_info.dart` |
| item_projeto.xml + ProjetoAdapter | `widgets/projeto_card.dart` |
| item_etapa.xml + EtapaAdapter | `widgets/etapa_card.dart` |
| item_equipe.xml + EquipeAdapter | `widgets/equipe_card.dart` |
| Usuario.java / Projeto.java / Etapa.java / Equipe.java | `models/*.dart` |

`dialog_editar_projeto.xml` não aparece referenciado em nenhuma Activity que
você enviou (o fluxo real de edição usa `layout_editar_projeto.xml`, dentro de
`DetalhesProjetoEtapaActivity.abrirDialogEditar()`); por isso não criei uma
tela separada para ele — parece um layout legado/não utilizado no app original.

## 5. Bibliotecas equivalentes

| Android | Flutter |
|---|---|
| Firebase Auth / Realtime Database / Storage | `firebase_auth`, `firebase_database`, `firebase_storage` |
| Glide | `cached_network_image` |
| `de.hdodenhof.circleimageview.CircleImageView` | `CircleAvatar` / `ClipOval` |
| `com.github.barteksc.pdfviewer.PDFView` | `syncfusion_flutter_pdfviewer` |
| `ActivityResultContracts` (galeria) | `image_picker` |
| `Linkify` / autoLink="web" | `url_launcher` |
| `PopupMenu` | `showModalBottomSheet` |
| `AlertDialog` | `showDialog` |
| TextWatcher de telefone (Cadastro/Perfil/Equipe) | `widgets/telefone_formatter.dart` (`TextInputFormatter`) |

## 6. Simplificações conscientes (leia antes de ir para produção)

- **MetodosActivity** baixava o PDF manualmente com `AsyncTask` + salvava em
  disco antes de exibir. Na versão Flutter, `SfPdfViewer.network(url)` faz
  isso internamente — mais simples e com o mesmo resultado para o usuário,
  mas sem cache em disco entre sessões (adicione se for importante).
- **Buscas no Realtime Database**: assim como no app original (`HomeFragment`,
  `ProjetosEtapasFragment`, `EtapaAdapter`), a versão Flutter também baixa o nó
  inteiro (`projetos`, `Etapas`) e filtra no cliente por `uid`. Isso é
  igual ao comportamento original, mas **não escala bem** com muitos usuários —
  vale migrar para queries indexadas (`orderByChild('uid').equalTo(uid)`) ou
  para o Cloud Firestore em algum momento.
- **Regras de segurança do Realtime Database** não foram enviadas nem
  analisadas aqui — confirme que suas regras (`database.rules.json`) impedem
  um usuário de ler/editar dados de outro, já que a filtragem por `uid` hoje
  acontece só no app, não no servidor.
- O ícone de cada card de projeto/etapa (`iconeAssetParaCategoria` /
  `iconeAssetParaEtapa` em `models/projeto.dart`) reproduz o `switch` original
  de `ProjetoAdapter`/`EtapasActivity`, mas agora aponta para assets locais em
  vez de `R.drawable.*` — troque os nomes se seus arquivos reais tiverem outro
  nome.
- Simplifiquei o "auto-cadastro do usuário logado como membro da própria
  equipe" (feito em `EquipeFragment.loadEquipe()` no Android) — hoje a aba
  Equipe só lista quem foi adicionado manualmente. Se quiser esse
  comportamento automático de volta, é fácil adicionar em `equipe_tab.dart`.

## 7. Próximos passos sugeridos

1. Rodar `flutter create .` (passo 2) e depois `flutter pub get` para baixar
   as dependências (não foi possível compilar/testar neste ambiente, que não
   tem o Flutter SDK instalado — revise antes de ir para produção).
2. Trocar os assets placeholder pelos originais (passo 3).
3. Revisar as regras do Realtime Database.
4. Testar o fluxo completo: cadastro → login → criar projeto → criar etapa →
   editar projeto → adicionar equipe → editar perfil → logout.
