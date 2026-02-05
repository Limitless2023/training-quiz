-- ============================================
-- 培训考核系统 - 数据库初始化
-- 在 Supabase SQL Editor 中执行此文件
-- ============================================

-- 1. 用户表
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  department TEXT NOT NULL,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(name, department)
);

-- 2. 培训考核表
CREATE TABLE IF NOT EXISTS quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  date DATE,
  trainer TEXT,
  description TEXT,
  passing_score INT DEFAULT 70,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. 题目表
CREATE TABLE IF NOT EXISTS questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('single', 'multiple', 'truefalse', 'fill')),
  question TEXT NOT NULL,
  options JSONB,
  answer JSONB NOT NULL,
  explanation TEXT,
  order_num INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. 答题记录表
CREATE TABLE IF NOT EXISTS attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE,
  score INT,
  correct_count INT,
  total INT,
  completed_at TIMESTAMPTZ DEFAULT now()
);

-- 5. 答题详情表
CREATE TABLE IF NOT EXISTS responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id UUID REFERENCES attempts(id) ON DELETE CASCADE,
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE,
  user_answer JSONB,
  is_correct BOOLEAN
);

-- ============================================
-- RLS 策略 (Row Level Security)
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE responses ENABLE ROW LEVEL SECURITY;

-- profiles: 所有人可读写
CREATE POLICY "Anyone can read profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Anyone can insert profiles" ON profiles FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update profiles" ON profiles FOR UPDATE USING (true);

-- quizzes: 所有人可读，admin 可写
CREATE POLICY "Anyone can read quizzes" ON quizzes FOR SELECT USING (true);
CREATE POLICY "Anyone can insert quizzes" ON quizzes FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update quizzes" ON quizzes FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete quizzes" ON quizzes FOR DELETE USING (true);

-- questions: 所有人可读写
CREATE POLICY "Anyone can read questions" ON questions FOR SELECT USING (true);
CREATE POLICY "Anyone can insert questions" ON questions FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update questions" ON questions FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete questions" ON questions FOR DELETE USING (true);

-- attempts: 所有人可读写
CREATE POLICY "Anyone can read attempts" ON attempts FOR SELECT USING (true);
CREATE POLICY "Anyone can insert attempts" ON attempts FOR INSERT WITH CHECK (true);

-- responses: 所有人可读写
CREATE POLICY "Anyone can read responses" ON responses FOR SELECT USING (true);
CREATE POLICY "Anyone can insert responses" ON responses FOR INSERT WITH CHECK (true);

-- ============================================
-- 索引
-- ============================================
CREATE INDEX IF NOT EXISTS idx_questions_quiz_id ON questions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_attempts_user_id ON attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_attempts_quiz_id ON attempts(quiz_id);
CREATE INDEX IF NOT EXISTS idx_responses_attempt_id ON responses(attempt_id);

-- ============================================
-- 导入 MeFlow Agent 培训题目
-- ============================================

-- 创建考核
INSERT INTO quizzes (id, title, date, trainer, description, passing_score) VALUES
('a1b2c3d4-0001-4000-8000-000000000001', 'MeFlow Agent 专题培训', '2026-02-05', '陈莉娟', 'MeFlow Agent 迭代功能、新应用场景、演示技巧及 Q1/Q2 规划', 70);

-- 导入 20 道题
INSERT INTO questions (quiz_id, type, question, options, answer, explanation, order_num) VALUES
('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 'Chat 合同功能中，用户如何精准定位需要修改的条款？',
 '["在对话框中输入条款编号","在合同文本中选中对应条款，系统会识别选中文本","通过下拉菜单选择条款","在搜索框中搜索条款关键词"]',
 '1', '用户可以在合同文本内选中对应条款，右下角会出现「选中文本」提示，Agent 能识别选中内容并进行精准修改。', 1),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 'Agent 修改合同条款后，修改痕迹以什么方式呈现？',
 '["直接覆盖原文，无痕迹","以批注形式标注在旁边","以修订模式呈现","生成独立的修改记录文档"]',
 '2', '所有修改痕迹都以修订模式（Track Changes）呈现，方便用户查看和确认修改内容。', 2),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '关于 Word 文档读取优化，以下哪项描述是正确的？',
 '["Agent 只能读取合同正文，无法获取批注","Agent 能获取合同文本、批注和修订记录","Agent 只能获取最新版本，无法识别修订痕迹","Agent 需要手动上传批注文件才能读取"]',
 '1', 'Agent 不仅能获取合同文本信息，还能获取合同中的批注和修订记录，且看到的是接受修订后的最新版本。', 3),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '当 Agent 在读取系统内合同数据和调用工具时，系统会出现什么视觉提示？',
 '["右上角出现加载旋转图标","页面左侧出现蓝色蒙层","对话框出现进度条","页面底部弹出提示条"]',
 '1', '当 Agent 在操作系统时，左侧会出现蓝色蒙层提示用户，运行完成后蒙层消失。', 4),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '如果 Agent 运行完成但蓝色蒙层仍然存在，应该如何处理？',
 '["等待系统自动恢复","联系技术支持","在右侧开一个新对话，然后刷新整个页面","关闭浏览器重新登录"]',
 '2', '如果蒙层没有消失，正常地在右侧开一个新对话，然后整个页面刷新一下即可。', 5),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 'Skill 机制的核心作用是什么？',
 '["替代 Agent 的基础对话功能","为 Agent 提供专业场景的知识或程序性知识","限制 Agent 的操作权限","提高 Agent 的对话速度"]',
 '1', 'Skill 机制通过文件夹压缩包的形式，为 Agent 提供专业场景的知识或程序性知识。', 6),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '一个 Skill 技能包通常包含哪些核心组成部分？',
 '["只包含一个 Word 文档","skill.md 文件和 reference 参考文件","一个 Python 脚本","一个 API 密钥文件"]',
 '1', 'Skill 技能包是压缩包形式，包含 skill.md 和 reference 文件夹。', 7),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '与把知识放在 Word 文档中让 Agent 调用相比，Skill 机制的优势是什么？',
 '["Skill 可以自动翻译多种语言","Skill 更加优雅，避免 Agent 调用知识时的困惑，提高效果","Skill 不需要任何人工维护","Skill 可以替代所有知识库功能"]',
 '1', '当知识量大、分类多时，Word 文档会让 Agent 困惑。Skill 机制更加优雅，能按场景精准调用。', 8),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 'Sub-agent（子 Agent）机制的主要优势是什么？',
 '["减少系统资源消耗","更聚焦、速度更快，可并行执行任务","完全替代主 Agent 的功能","不需要任何配置即可使用"]',
 '1', '子 Agent 机制的优势在于更聚焦、速度更快，主 Agent 负责任务编排和结果融合。', 9),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '在使用 Agent 对话时，如果前面已有很多上下文，接下来要执行复杂任务，建议怎么做？',
 '["继续在当前对话中操作","清除浏览器缓存","开一个新对话，避免上下文干扰","切换到其他浏览器"]',
 '2', '前面的上下文太多会影响下一个任务的效果，建议新开对话。', 10),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '人工反馈机制中，用户点踩时可以选择哪些反馈类型？',
 '["只能输入自由文本","预设了几种常见问题场景，也可直接输入其他问题","只能选择「不满意」","只能发送截图反馈"]',
 '1', '点踩时预设了几种常见问题场景供选择，也可直接输入其他问题。', 11),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '智能化需求的「六要素框架」包含哪些要素？',
 '["需求、设计、开发、测试、部署、运维","谁、在系统中什么时候、按什么标准、对什么东西、做什么动作、结果给谁","输入、处理、输出、反馈、优化、迭代","用户、场景、功能、数据、接口、界面"]',
 '1', '六要素：谁在系统中什么时候让 Agent 按照什么标准，对什么样的东西做什么动作，结果给谁用。', 12),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '演示 Agent 时，以下哪项是需要避免的？',
 '["结合具体业务场景演示","调整浏览器缩放比例保证美观","强调 Agent 什么都能做，以抬高客户兴趣","让 Agent 帮忙构思演示用的 Prompt"]',
 '2', '不要说「Agent 什么都能做」，避免过度抬高客户预期。', 13),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '主动型 Agent 与手动对话型 Agent 的核心区别是什么？',
 '["主动型 Agent 使用不同的 AI 模型","主动型 Agent 在后台预设了触发场景和条件，自动执行任务","主动型 Agent 只能执行简单任务","主动型 Agent 不需要任何 Prompt"]',
 '1', '主动型 Agent 通过在系统后台预设触发场景、条件和任务要求，在特定环节自动触发执行。', 14),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '关于不同 AI 模型的使用，以下哪项建议是正确的？',
 '["所有模型效果完全一样，随意选择即可","在一个对话中频繁切换模型效果更好","建议同一对话使用同一模型，换模型时新开对话","只使用系统默认模型，不要更换"]',
 '2', '推荐在一个对话窗口中使用同一个模型，换模型时建议新开对话。', 15),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 'Q1/Q2 计划中，「引用定位」功能是指什么？',
 '["引用外部法律法规数据库","Agent 列出内容对应的合同条款位置，并在系统中可定位到该条款","自动引用历史合同模板","在搜索引擎中定位相关案例"]',
 '1', '引用定位功能让 Agent 列出内容对应的合同条款位置，后续可在系统中定位。', 16),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '集成平台在 MeFlow Agent 中的作用是什么？',
 '["仅用于用户管理和权限控制","提供应用（如发送飞书消息）可作为 Agent 的 Tools 使用","用于替代 Agent 的对话功能","仅用于数据备份"]',
 '1', '集成平台里的应用可以作为 Agent 的 Tools，如发送飞书/钉钉消息等。', 17),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '用户在合同生成场景中，如何直接获取合同文档？',
 '["必须在系统中发起起草流程后才能下载","可以在 Prompt 中直接要求 Agent 生成合同文档，生成后出现下载按钮","需要联系管理员导出","只能通过邮件接收"]',
 '1', '用户可直接要求 Agent 生成合同文档，生成后出现下载按钮。', 18),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '关于 Skill 的创建，以下说法正确的是？',
 '["Skill 只能由开发人员手动编写代码创建","可以先从业务专家获取隐性知识，再让 AI 帮忙生成标准格式的 Skill","Skill 必须从官方商店购买","Skill 一旦创建就不能修改"]',
 '1', '先从业务专家获取隐性知识，然后让 AI 基于需求生成标准格式的 Skill。', 19),

('a1b2c3d4-0001-4000-8000-000000000001', 'single',
 '目前关于 Memory（记忆调优）功能，对外沟通时应注意什么？',
 '["可以大力宣传这个功能","现阶段不建议对外表述，避免过度抬高客户预期","只向大客户介绍","作为免费功能对外推广"]',
 '1', '现阶段不建议对外表述，避免过多地抬高客户预期。', 20);
