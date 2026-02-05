#!/bin/bash
# Import training quiz data to Supabase
set -e

SUPABASE_URL="https://qdipqdysblxckgkcpnqj.supabase.co"
SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkaXBxZHlzYmx4Y2tna2NwbnFqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDMwMDQ0MiwiZXhwIjoyMDg1ODc2NDQyfQ.vhL2Irs10MHQHXOfWlp4vwitf0T1syHUsT7sQcyHeqI"

# Common curl options
CURL_OPTS="--noproxy '*' -s -w '\nHTTP_STATUS:%{http_code}'"
HEADERS="-H 'apikey: ${SERVICE_KEY}' -H 'Authorization: Bearer ${SERVICE_KEY}' -H 'Content-Type: application/json' -H 'Prefer: return=representation'"

echo "=== Step 1: Insert Quizzes ==="

# Quiz 2: MeFlow 3.0 全流程操作培训
echo "Inserting quiz 2 (fullprocess)..."
RESULT=$(curl --noproxy '*' -s -w '\nHTTP_STATUS:%{http_code}' \
  -X POST "${SUPABASE_URL}/rest/v1/quizzes" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{
    "id": "a1b2c3d4-0002-4000-8000-000000000001",
    "title": "MeFlow 3.0 系统全流程操作培训",
    "date": "2026-02-04",
    "trainer": "王冬雨、李香香",
    "description": "MF3.0 合同起草/评审/审批/签署/归档/履约/变更 全生命周期操作培训",
    "passing_score": 70
  }')
echo "$RESULT" | tail -1

# Quiz 3: MeFlow 3.0 技术介绍专题培训
echo "Inserting quiz 3 (tech)..."
RESULT=$(curl --noproxy '*' -s -w '\nHTTP_STATUS:%{http_code}' \
  -X POST "${SUPABASE_URL}/rest/v1/quizzes" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{
    "id": "a1b2c3d4-0003-4000-8000-000000000001",
    "title": "MeFlow 3.0 技术介绍专题培训",
    "date": "2026-02-05",
    "trainer": "赵世昌",
    "description": "MF3.0 技术架构、性能升级、数据隔离、定制开发、客户二开、代码交付等级",
    "passing_score": 70
  }')
echo "$RESULT" | tail -1

echo ""
echo "=== Step 2: Insert Questions for Quiz 2 (fullprocess) ==="

# Questions for fullprocess training
curl --noproxy '*' -s -o /dev/null -w "Q2 questions: HTTP %{http_code}\n" \
  -X POST "${SUPABASE_URL}/rest/v1/questions" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '[
    {"id":"c1c2c3d4-2001-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"MF3.0 稳定版于什么时间发布？","options":["1月15日","1月31日","2月4日","2月14日"],"answer":"1","explanation":"王冬雨介绍 MF3.0 稳定版于1月31日发布，清理了600多个 bug，流程基本走通，PRD 已上线。","order_num":1},
    {"id":"c1c2c3d4-2002-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"合同起草中，为解决多相对方信息填写问题，系统采用了什么方案？","options":["为每个相对方创建独立表单","用表格处理，实现级联选择","通过弹窗逐个填写","导入 Excel 批量填写"],"answer":"1","explanation":"3.0 将外部相对方和内部相对方信息用表格处理，实现级联选择，解决多相对方信息填写问题。","order_num":2},
    {"id":"c1c2c3d4-2003-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"主流程中「用户操作网关」的作用是什么？","options":["限制用户的操作权限","让用户自行选择进入的流程","自动判断流程走向","记录用户的操作日志"],"answer":"1","explanation":"用户操作网关让用户自己选择要进入哪一个流程，例如发起评审或发起审批。也可以根据条件判断自动走流程。","order_num":3},
    {"id":"c1c2c3d4-2004-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"truefalse","question":"MF3.0 的主流程配置是完全固定的，不支持自定义修改。","options":["正确","错误"],"answer":"1","explanation":"MF3.0 的主流程是高度可配置的，从起草、评审、审批到签署、归档、履约的整个流程图都可以自定义配置。","order_num":4},
    {"id":"c1c2c3d4-2005-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"评审规则分为哪两类评审节点？","options":["内部评审和外部评审","单轮评审和多轮评审","自动评审和手动评审","初审和终审"],"answer":"1","explanation":"评审规则分为单轮评审和多轮评审。单轮适用于一次性评审，多轮用于多次反复协商交互。","order_num":5},
    {"id":"c1c2c3d4-2006-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"评审流程中，驱动节点间流转的核心操作是什么？","options":["点击「下一步」按钮","上传新版本（开启新轮次）","发送评审通知","填写评审意见"],"answer":"1","explanation":"评审流程节点之间的驱动都是靠上传新版本来实现，上传新版本会开启新轮次，进入下一个评审节点。","order_num":6},
    {"id":"c1c2c3d4-2007-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"multiple","question":"本次系统导航栏新增了哪些功能模块？（多选）","options":["批量功能","变更功能","模板组功能","统计功能","履约功能","知识库功能"],"answer":"[0,1,2,3,4]","explanation":"本次导航栏新增了批量、变更、模板组、统计、履约等功能模块。","order_num":7},
    {"id":"c1c2c3d4-2008-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"「模板组起草」功能适用于什么场景？","options":["同时起草多份不同类型的合同","主合同需要附带附件一起签署","多人协作编辑同一份合同","从历史合同中复制模板"],"answer":"1","explanation":"模板组起草适用于如采购合同需供应商签署质量保证协议、保密协议等附件的场景。","order_num":8},
    {"id":"c1c2c3d4-2009-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"WPS 编辑器切换功能预计在什么时间完成开发？","options":["已完成","今年一季度或二季度","今年下半年","明年"],"answer":"1","explanation":"WPS 切换功能预计今年一季度或二季度完成开发，目前正在做技术可行性验证。","order_num":9},
    {"id":"c1c2c3d4-2010-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"multiple","question":"合同电子签标品目前接入了哪些平台？（多选）","options":["e 签宝","法大大","腾讯电子签","DocuSign"],"answer":"[0,1]","explanation":"电子签标品目前接了两个平台：e签宝和法大大，与2.0保持一致。","order_num":10},
    {"id":"c1c2c3d4-2011-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"truefalse","question":"「发起组织」功能是所有公司都需要的通用必填项。","options":["正确","错误"],"answer":"1","explanation":"发起组织功能目前约30%的公司有此需求，建议作为可配置项默认隐藏。","order_num":11},
    {"id":"c1c2c3d4-2012-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"多轮评审中，「本轮定稿」后系统提供哪两种操作选择？","options":["保存草稿/提交审批","完成评审/上传新版本继续评审","通过/拒绝","下载文件/发送邮件"],"answer":"1","explanation":"多轮评审本轮定稿后，可以「完成评审」或「上传新版本」开启新轮次继续评审。","order_num":12},
    {"id":"c1c2c3d4-2013-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"fill","question":"变更合同的编号规则是在原合同编号后面加上 ____（填写格式）。","options":[],"answer":"\"杠1至杠n\"","explanation":"变更合同编号在原编号上杠1至杠n，如原编号 HT-001 变更后为 HT-001-1。","order_num":13},
    {"id":"c1c2c3d4-2014-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"multiple","question":"审批环节支持哪些操作功能？（多选）","options":["审批通过","拒绝","抄送","转交","加签","撤回"],"answer":"[0,1,2,3,4]","explanation":"审批环节支持审批通过、拒绝、抄送、转交、加签等功能。","order_num":14},
    {"id":"c1c2c3d4-2015-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"归档时上传归档件的主要目的是什么？","options":["仅作为存档备份","与审批完的文件进行比对，确认文件无篡改","自动生成合同摘要","触发签署流程"],"answer":"1","explanation":"归档时上传归档件后，可与审批完的文件进行比对，确认文件是否一致。","order_num":15},
    {"id":"c1c2c3d4-2016-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"truefalse","question":"履约看板只有月视图一种展示形式。","options":["正确","错误"],"answer":"1","explanation":"履约看板提供多种视图：月视图、周视图、列表视图等不同展示形式。","order_num":16},
    {"id":"c1c2c3d4-2017-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"付款申请审批完成后，系统如何处理对应的履约计划？","options":["必须手动完成","自动删除计划","可配置为自动完成或手动完成","直接标记为已过期"],"answer":"2","explanation":"付款申请审批完成后，可以配置为自动完成履约计划或手动完成。","order_num":17},
    {"id":"c1c2c3d4-2018-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"single","question":"合同比对中 OCR 升级的预计完成时间是？","options":["2月底","3月底","6月底","年底"],"answer":"1","explanation":"陈翱介绍OCR比对预计3月底有一版，将外采OCR并修复现有问题。","order_num":18},
    {"id":"c1c2c3d4-2019-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"fill","question":"MF3.0 稳定版发布前清理了约 ____ 个 bug。","options":[],"answer":"\"600\"","explanation":"MF3.0 稳定版清理了600多个bug，流程基本走通。","order_num":19},
    {"id":"c1c2c3d4-2020-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","type":"multiple","question":"合同变更支持哪些变更方式？（多选）","options":["补充","终止","解除","续签","撤销"],"answer":"[0,1,2]","explanation":"变更方式支持补充、终止、解除等方式。","order_num":20}
  ]'

echo ""
echo "=== Step 3: Insert Questions for Quiz 3 (tech) ==="

curl --noproxy '*' -s -o /dev/null -w "Q3 questions: HTTP %{http_code}\n" \
  -X POST "${SUPABASE_URL}/rest/v1/questions" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '[
    {"id":"c1c2c3d4-3001-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"MF3.0 主服务后端技术改用了什么编程语言？","options":["Python","Java","Go","Node.js"],"answer":"1","explanation":"MF3.0 主服务后端改成了 Java，前端改成了 React。","order_num":1},
    {"id":"c1c2c3d4-3002-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"MF3.0 主服务前端技术改用了什么框架？","options":["Vue","Angular","React","Svelte"],"answer":"2","explanation":"主服务前端改成了 React 框架。","order_num":2},
    {"id":"c1c2c3d4-3003-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"3.0 中列表页数据查询完全基于什么技术实现？","options":["MySQL 直接查询","MongoDB 聚合查询","Elasticsearch (ES)","Redis 缓存查询"],"answer":"2","explanation":"3.0 列表页数据完全基于 ES，实现查询和存储分离，轻松应对百万级数据。","order_num":3},
    {"id":"c1c2c3d4-3004-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"3.0 的「查询和存储分离」策略中，数据的增删改操作基于什么？","options":["MySQL","Elasticsearch","MongoDB","Redis"],"answer":"2","explanation":"增删改基于 MongoDB，查询基于 ES。","order_num":4},
    {"id":"c1c2c3d4-3005-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"3.0 的数据安全隔离采用什么方式？","options":["逻辑隔离","物理隔离（数据库按租户独立部署）","加密隔离","网络隔离"],"answer":"1","explanation":"3.0 采用物理隔离，数据库按租户独立部署，尤其针对 SaaS 场景。","order_num":5},
    {"id":"c1c2c3d4-3006-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"truefalse","question":"MF2.0 的数据隔离方式也是物理隔离。","options":["正确","错误"],"answer":"1","explanation":"2.0 是逻辑隔离，依赖于研发人员代码层面的自觉性。3.0 才改为物理隔离。","order_num":6},
    {"id":"c1c2c3d4-3007-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"以李宁项目压测数据为例，3.0 合同台账页面的平均响应时间是多少？","options":["2.1 秒","0.21 秒","0.021 秒","1.28 秒"],"answer":"1","explanation":"3.0 压测数据显示，平均响应时间为 0.21 秒，QPS 达到 1128。","order_num":7},
    {"id":"c1c2c3d4-3008-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"3.0 压测中 QPS 最高达到多少？","options":["25.55","256","1128","3000"],"answer":"2","explanation":"3.0 的 QPS 达到 1128，而 2.0 仅为 25.55，性能提升约 44 倍。","order_num":8},
    {"id":"c1c2c3d4-3009-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"multiple","question":"MySQL 可以切换为哪些关系型数据库？（多选）","options":["Oracle","达梦","PostgreSQL","人大金仓","SQLite"],"answer":"[0,1,2,3]","explanation":"支持切换为 Oracle、达梦、PostgreSQL、人大金仓等主流数据库。","order_num":9},
    {"id":"c1c2c3d4-3010-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"RabbitMQ 在 MF3.0 系统中主要承担什么角色？","options":["文件存储","异步数据处理和消息队列","用户认证","日志管理"],"answer":"1","explanation":"RabbitMQ 用于异步数据处理，包括异步数据更新和消息集成。","order_num":10},
    {"id":"c1c2c3d4-3011-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"对象存储在系统中主要用于什么？","options":["数据库备份","文件存储（DOCX、PDF 等合同文件）","缓存加速","日志记录"],"answer":"1","explanation":"对象存储用于文件存储，包括 DOCX、PDF 等合同文件和临时文件。","order_num":11},
    {"id":"c1c2c3d4-3012-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"truefalse","question":"MF3.0 内置了集成平台，不需要像 2.0 那样额外部署。","options":["正确","错误"],"answer":"0","explanation":"3.0 直接内置集成平台，包含触发器、应用和集成流。2.0 则需要额外部署。","order_num":12},
    {"id":"c1c2c3d4-3013-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"集成平台包含哪三大核心组件？","options":["数据库、缓存、消息队列","触发器、应用、集成流","前端、后端、中间件","监控、告警、日志"],"answer":"1","explanation":"集成平台内置触发器、应用和集成流三大核心组件。","order_num":13},
    {"id":"c1c2c3d4-3014-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"关于 WPS 切换，Q1 预计推出的版本有什么限制？","options":["完全兼容没有限制","部分功能可能受限（如涉及书签的功能）","只支持查看不支持编辑","只支持 Windows 系统"],"answer":"1","explanation":"预计 Q1 出一版 WPS 版本，但涉及书签的功能（如留言定位、模板挖空）还在验证中。","order_num":14},
    {"id":"c1c2c3d4-3015-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"fill","question":"3.0 的审计日志默认存储 ____。","options":[],"answer":"\"半年\"","explanation":"审计日志默认存储半年，可根据用户需求调整。","order_num":15},
    {"id":"c1c2c3d4-3016-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"3.0 标准资源配置大约需要几台服务器？","options":["1台","2台","3台","5台"],"answer":"2","explanation":"标准配置总体是三台服务器（16G 和 32G 资源配置）。","order_num":16},
    {"id":"c1c2c3d4-3017-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"multiple","question":"3.0 支持哪些部署方式？（多选）","options":["容器化部署（K8S/C3S 集群）","Docker Compose 部署","物理机/虚拟机部署","Serverless 部署"],"answer":"[0,1,2]","explanation":"支持容器化部署、Docker Compose 部署和物理机/虚拟机部署。","order_num":17},
    {"id":"c1c2c3d4-3018-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"MF3.0 代码交付分为几级？","options":["2级","3级","4级","5级"],"answer":"2","explanation":"代码交付分四级：一级供扫描；二级含定制代码；三级含标品源码；四级为内部基础服务。","order_num":18},
    {"id":"c1c2c3d4-3019-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"single","question":"二级交付包含什么内容？","options":["仅交付使用手册","依赖 jar 包和定制代码，可编译运行但不含标品源码","所有标品源代码","包含内部基础服务代码"],"answer":"1","explanation":"二级交付包含依赖 jar 包和定制代码，可编译运行但不含标品源码。","order_num":19},
    {"id":"c1c2c3d4-3020-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","type":"truefalse","question":"三级交付（含标品主模块源代码）任何人都可以直接审批通过。","options":["正确","错误"],"answer":"1","explanation":"三级交付需要非常谨慎，必须找乐哥审批。四级交付还需要找超霸审批。","order_num":20}
  ]'

echo ""
echo "=== Step 4: Insert Training Segments ==="

# Segments for Quiz 2 (fullprocess) - 20 chapters
echo "Inserting segments for quiz 2..."
curl --noproxy '*' -s -o /dev/null -w "Q2 segments: HTTP %{http_code}\n" \
  -X POST "${SUPABASE_URL}/rest/v1/training_segments" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '[
    {"id":"b1b2c3d4-2001-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":1,"title":"MF3.0稳定版情况及合同起草功能演示","timestamp":"00:14","content":"王冬雨介绍MF3.0稳定版情况，1月31日发布，清了600多个bug，待验收后发通知。接着演示合同起草功能改版，表格处理优化解决多相对方信息填写问题。"},
    {"id":"b1b2c3d4-2002-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":2,"title":"系统主流程配置、表单校验及多主体流程方案","timestamp":"13:49","content":"介绍流程操作及配置，用户操作网关可自由选择流程或条件判断。表单校验较复杂，主流程针对超级管理员和各租户，可加条件分支适配多主体不同流程。"},
    {"id":"b1b2c3d4-2003-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":3,"title":"主流程发起评审介绍及评审规则配置说明","timestamp":"19:18","content":"评审规则分单轮和多轮，单轮适用于需法务过一道的场景，多轮用于多次反复协商交互。"},
    {"id":"b1b2c3d4-2004-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":4,"title":"MF3.0评审流程演示、问题讨论及调整计划","timestamp":"20:19","content":"介绍评审流程，包括上传新版本开启新轮次、多轮评审后定稿及完成评审等操作，系统支持按钮自定义配置。"},
    {"id":"b1b2c3d4-2005-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":5,"title":"系统导航栏功能改造及新增功能介绍","timestamp":"28:48","content":"导航栏改造增加了批量、变更、模板组、统计、履约等功能。"},
    {"id":"b1b2c3d4-2006-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":6,"title":"合同全生命周期讲解及发起组织配置讨论","timestamp":"29:20","content":"合同全生命周期从合同发起开始，支持起草变更、批量起草。发起组织约30%公司有此需求，建议作为可配置项默认隐藏。"},
    {"id":"b1b2c3d4-2007-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":7,"title":"功能系统起草形式及模板组起草场景介绍","timestamp":"31:48","content":"起草形式分为模板起草和上传文件起草。模板组起草适用于采购合同需附带质量保证协议、保密协议等附件的场景。"},
    {"id":"b1b2c3d4-2008-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":8,"title":"合同起草环节功能更新、数据处理及签署说明","timestamp":"32:54","content":"WPS切换功能预计今年一季度或二季度完成。选合同类型是影响主流程流转关键要素。签署方式有电子签和线下签，电子签接e签宝和法大大。"},
    {"id":"b1b2c3d4-2009-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":9,"title":"合同起草环节履约表单问题及功能规划","timestamp":"36:18","content":"围绕合同表单及履约计划相关问题展开，计算功能可根据不同税率算出对应金额。"},
    {"id":"b1b2c3d4-2010-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":10,"title":"合同提交审核功能规划及评审功能普及安排","timestamp":"40:26","content":"提交审核功能未做，后续会补上。管理后台支持按不同条件匹配评审人员。"},
    {"id":"b1b2c3d4-2011-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":11,"title":"评审功能进度、轮次概念及邀请催办介绍","timestamp":"42:53","content":"评审分享功能330时上线。评审轮次概念，单轮解决流程式评审问题。可对评审人进行催办发消息提醒。"},
    {"id":"b1b2c3d4-2012-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":12,"title":"修改合同留言功能及附件评审功能介绍","timestamp":"44:14","content":"留言处为富文本编辑器，能换行、插图片、放附件。附件有单独区域，目前未做附件评审。"},
    {"id":"b1b2c3d4-2013-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":13,"title":"合同评审流程、功能问题及优化方案探讨","timestamp":"46:03","content":"将不通过改为协议件完成评审避免歧义；解决评审按钮混乱及流程不清问题。"},
    {"id":"b1b2c3d4-2014-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":14,"title":"合同比对功能升级计划、成本及时间安排","timestamp":"54:33","content":"OCR会外采，也有开源版本，现存问题将修复。历史客户升级成本可忽略，预计3月底出新版。"},
    {"id":"b1b2c3d4-2015-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":15,"title":"合同评审定稿及智能审查融合规划讨论","timestamp":"01:04:19","content":"探讨智能审查与3.0融合形态，预计Q2进行更深融合。"},
    {"id":"b1b2c3d4-2016-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":16,"title":"评审完成后发起审批按钮延迟问题处理","timestamp":"01:14:04","content":"因异步加载，评审结束发起审批的操作按钮更新慢，原因是合同流程状态未实时更新。"},
    {"id":"b1b2c3d4-2017-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":17,"title":"合同审批环节功能介绍与相关需求讨论","timestamp":"01:15:46","content":"审批环节支持审批通过、拒绝、抄送、转交、加签等功能。讨论了审批节点去重等情况。"},
    {"id":"b1b2c3d4-2018-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":18,"title":"合同签署、归档流程及相关问题探讨","timestamp":"01:23:56","content":"签署支持线下签和电子签。归档时可上传文件进行比对，还可配置生效日期字段。"},
    {"id":"b1b2c3d4-2019-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":19,"title":"履约管理流程、付款申请及状态配置介绍","timestamp":"01:39:44","content":"履约环节包括台账、看板（月视图、周视图等）。付款申请有独立审批流程，完成后可配置自动或手动完成履约计划。"},
    {"id":"b1b2c3d4-2020-4000-8000-000000000001","quiz_id":"a1b2c3d4-0002-4000-8000-000000000001","chapter_num":20,"title":"合同变更功能介绍、问题讨论及后续安排","timestamp":"01:52:17","content":"变更方式支持补充、终止、解除等。变更合同编号规则为在原编号上杠1至杠n。字段修改可按需配置。"}
  ]'

# Segments for Quiz 3 (tech) - 12 chapters
echo "Inserting segments for quiz 3..."
curl --noproxy '*' -s -o /dev/null -w "Q3 segments: HTTP %{http_code}\n" \
  -X POST "${SUPABASE_URL}/rest/v1/training_segments" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '[
    {"id":"b1b2c3d4-3001-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":1,"title":"3.0技术架构介绍及数据库、编辑器切换说明","timestamp":"02:31","content":"赵世昌介绍3.0技术架构，主服务后端改Java、前端改React。介绍Mysql、Rabbitmq等用途及切换方式，编辑器可换WPS。"},
    {"id":"b1b2c3d4-3002-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":2,"title":"系统3.0对比2.0的核心升级及典型问题","timestamp":"14:42","content":"核心升级包括：性能升级（列表页基于ES）、数据安全物理隔离、灵活扩展定制、数据库切换、按需部署、内置集成平台。"},
    {"id":"b1b2c3d4-3003-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":3,"title":"系统性能压测指标、场景及数据情况说明","timestamp":"26:42","content":"以李宁项目压测为例，2.0数据量1000+并发100 QPS 25.55；3.0平均响应时间0.21秒QPS达1128。"},
    {"id":"b1b2c3d4-3004-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":4,"title":"系统3.0技术栈及相关功能特性介绍","timestamp":"32:50","content":"数据安全权限控制、双因子待实现、链路追踪改进、流程引擎基于flowable、移动端适配、oauth单点登录、消息集成飞书已完成。"},
    {"id":"b1b2c3d4-3005-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":5,"title":"3.0日志情况、存储策略及服务资源配置说明","timestamp":"40:49","content":"日志审计默认存储半年可调整。组件开源无侵权风险，服务资源配置与2.0总体无变化。"},
    {"id":"b1b2c3d4-3006-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":6,"title":"服务器部署资源分配、高可用及适配减配说明","timestamp":"43:28","content":"标准配置三台服务器（16G和32G），测试环境可减配。高可用需服务部署两个节点以上且在不同机器。"},
    {"id":"b1b2c3d4-3007-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":7,"title":"系统部署方式、审计日志及专有名词说明","timestamp":"47:41","content":"支持容器化部署（K8S/C3S）、Docker Compose部署、物理机/虚拟机部署。审计日志默认存储半年。"},
    {"id":"b1b2c3d4-3008-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":8,"title":"客户二开难度及开发文档完善情况介绍","timestamp":"49:11","content":"相比2.0客户二开难度大幅降低，可在不开放核心源码下对照研发文档开发后端。部分功能可借助集成平台做轻定制。"},
    {"id":"b1b2c3d4-3009-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":9,"title":"集成平台二开难度、亮点优势及演示策略","timestamp":"51:42","content":"集成平台亮点包括自定义触发器、对外暴露接口、在不改动核心代码下完成数据集成。建议演示时上手试最简单集成流。"},
    {"id":"b1b2c3d4-3010-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":10,"title":"产品版本升级情况：轻定制可丝滑，重定制需评估","timestamp":"54:45","content":"以海天项目为例，轻定制可丝滑升级直接拿标品最新代码发布。重定制涉及模块复写需评估，但升级成本低于2.0。"},
    {"id":"b1b2c3d4-3011-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":11,"title":"海天项目架构亮点、数据安全及审批POC探讨","timestamp":"57:45","content":"系统灵活可配置（插件扩展、数据项、集成平台）。数据安全受制于用户权限，可脱敏过滤。目前检索用ES，后续或引入向量数据库。"},
    {"id":"b1b2c3d4-3012-4000-8000-000000000001","quiz_id":"a1b2c3d4-0003-4000-8000-000000000001","chapter_num":12,"title":"MF3.0源代码交付等级说明及相关安排","timestamp":"01:04:06","content":"代码交付分四级：一级仅供安全扫描；二级含jar包和定制代码可编译运行不含标品源码；三级含标品主模块源代码需乐哥审批；四级为内部基础服务一般不交付。"}
  ]'

echo ""
echo "=== Step 5: Insert Question Sources ==="

# Question sources for Quiz 2 (mapping questions to chapters)
echo "Inserting question sources for quiz 2..."
curl --noproxy '*' -s -o /dev/null -w "Q2 sources: HTTP %{http_code}\n" \
  -X POST "${SUPABASE_URL}/rest/v1/question_sources" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '[
    {"question_id":"c1c2c3d4-2001-4000-8000-000000000001","segment_id":"b1b2c3d4-2001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2002-4000-8000-000000000001","segment_id":"b1b2c3d4-2001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2003-4000-8000-000000000001","segment_id":"b1b2c3d4-2002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2004-4000-8000-000000000001","segment_id":"b1b2c3d4-2002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2005-4000-8000-000000000001","segment_id":"b1b2c3d4-2003-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2006-4000-8000-000000000001","segment_id":"b1b2c3d4-2004-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2007-4000-8000-000000000001","segment_id":"b1b2c3d4-2005-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2008-4000-8000-000000000001","segment_id":"b1b2c3d4-2007-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2009-4000-8000-000000000001","segment_id":"b1b2c3d4-2008-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2010-4000-8000-000000000001","segment_id":"b1b2c3d4-2008-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2011-4000-8000-000000000001","segment_id":"b1b2c3d4-2006-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2012-4000-8000-000000000001","segment_id":"b1b2c3d4-2004-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2013-4000-8000-000000000001","segment_id":"b1b2c3d4-2020-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2014-4000-8000-000000000001","segment_id":"b1b2c3d4-2017-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2015-4000-8000-000000000001","segment_id":"b1b2c3d4-2018-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2016-4000-8000-000000000001","segment_id":"b1b2c3d4-2019-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2017-4000-8000-000000000001","segment_id":"b1b2c3d4-2019-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2018-4000-8000-000000000001","segment_id":"b1b2c3d4-2014-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2019-4000-8000-000000000001","segment_id":"b1b2c3d4-2001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-2020-4000-8000-000000000001","segment_id":"b1b2c3d4-2020-4000-8000-000000000001"}
  ]'

# Question sources for Quiz 3 (mapping questions to chapters)
echo "Inserting question sources for quiz 3..."
curl --noproxy '*' -s -o /dev/null -w "Q3 sources: HTTP %{http_code}\n" \
  -X POST "${SUPABASE_URL}/rest/v1/question_sources" \
  -H "apikey: ${SERVICE_KEY}" \
  -H "Authorization: Bearer ${SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=minimal" \
  -d '[
    {"question_id":"c1c2c3d4-3001-4000-8000-000000000001","segment_id":"b1b2c3d4-3001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3002-4000-8000-000000000001","segment_id":"b1b2c3d4-3001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3003-4000-8000-000000000001","segment_id":"b1b2c3d4-3002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3004-4000-8000-000000000001","segment_id":"b1b2c3d4-3002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3005-4000-8000-000000000001","segment_id":"b1b2c3d4-3002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3006-4000-8000-000000000001","segment_id":"b1b2c3d4-3002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3007-4000-8000-000000000001","segment_id":"b1b2c3d4-3003-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3008-4000-8000-000000000001","segment_id":"b1b2c3d4-3003-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3009-4000-8000-000000000001","segment_id":"b1b2c3d4-3001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3010-4000-8000-000000000001","segment_id":"b1b2c3d4-3001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3011-4000-8000-000000000001","segment_id":"b1b2c3d4-3001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3012-4000-8000-000000000001","segment_id":"b1b2c3d4-3002-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3013-4000-8000-000000000001","segment_id":"b1b2c3d4-3009-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3014-4000-8000-000000000001","segment_id":"b1b2c3d4-3001-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3015-4000-8000-000000000001","segment_id":"b1b2c3d4-3005-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3016-4000-8000-000000000001","segment_id":"b1b2c3d4-3006-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3017-4000-8000-000000000001","segment_id":"b1b2c3d4-3007-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3018-4000-8000-000000000001","segment_id":"b1b2c3d4-3012-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3019-4000-8000-000000000001","segment_id":"b1b2c3d4-3012-4000-8000-000000000001"},
    {"question_id":"c1c2c3d4-3020-4000-8000-000000000001","segment_id":"b1b2c3d4-3012-4000-8000-000000000001"}
  ]'

echo ""
echo "=== Import Complete ==="
