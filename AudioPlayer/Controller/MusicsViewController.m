//
//  MusicsViewController.m
//  AudioPlayer
//
//  Created by 15240496 on 16/4/1.
//  Copyright © 2016年 15240496. All rights reserved.
//

#import "MusicsViewController.h"
#import "AudioPlayerController.h"
#import "MusicModel.h"
#import "DB.h"

@interface MusicsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *songTableView;
@property (nonatomic, strong) NSMutableArray *songArray;

@end

static NSString *songIdentifier = @"songCellIdentifier";
@implementation MusicsViewController

- (NSMutableArray *)songArray
{
    if (!_songArray) {
        _songArray = [NSMutableArray array];
    }
    return _songArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"音乐列表";
    [self creatTableView];
    [self dataJson];
}

// 初始化歌曲列表数据
-(void)dataJson
{
    [DB createMusicTable];
    [DB insertMusicWithID:10000 name:@"I Believe" icon:@"http://p3.music.126.net/1W118vLAePcixn_Ckg2xUQ==/1376588561547944.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=407679949.mp3" singer:@"张信哲" introduce:@"《I Believe》由金亨熙作曲，金亨熙、申升勋填词；2001年，歌曲作为韩国电影《我的野蛮女友》主题曲，由申升勋演唱；2016年，《I Believe》作为《我的新野蛮女友》电影的主题曲，由张信哲演唱。同时该歌曲因其经典旋律，在中国内地、中国台湾，中国香港均被不同填词翻唱过。2001年，《I Believe》作为韩国电影《我的野蛮女友》主题曲，是根据《我的野蛮女友》中爆笑有趣又浪漫感人的剧情所量身制作的音乐。《我的野蛮女友》在韩国创下500万观影人次的纪录，伴随着韩国影片《我的野蛮女友》的走红，其主题歌《IBelieve》也受到关注 。2016年，《我的野蛮女友》制作公司推出电影《我的新野蛮女友》并在此将《I Believe》作为主题曲，同时中文版由张信哲演唱"];
    [DB insertMusicWithID:10001 name:@"LIAR LIAR" icon:@"http://p3.music.126.net/THS5HMOjmKNDDCj9G0ROyQ==/1376588561547947.jpg" fileName:@"http://m2.music.126.net/dUZxbXIsRXpltSFtE7Xphg==/1375489050352559.mp3" singer:@"OH MY GIRL" introduce:@"《LIAR LIAR》是韩国女子组合OH MY GIRL第三张EP专辑《PINK OCEAN》的主打曲，于2016年3月28日发布 ，歌曲以中韩两种语言录制发行，中文版被收录进OH MY GIRL于2016年5月26日发行的第三张EP专辑的后续专辑《WINDY DAY》中 。OHMYGIRL第三张EP《PINK OCEAN》的主打歌《LIAR LIAR》是首轻快、活泼的流行舞曲，内容描绘少女们自己深陷爱情漩涡的心情，感到有所怀疑，因而陷入一些奇怪想象当中的故事。"];
    [DB insertMusicWithID:10002 name:@"正义之手" icon:@"http://p3.music.126.net/xXrsv_rI6Qucb1dxibve4A==/3272146615759748.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=407679997.mp3" singer:@"SNH48" introduce:@"《正义之手》是SNH48 Team NII演唱的歌曲，由小7作词，罗龙杰作曲，收录于SNH48EP《源动力》中。这首歌曲按照李宇琪的特色进行重新混音，让她浑厚的音色和节奏感得以发挥，并由李宇琪亲自演唱。《正义之手》我们都是勇者，守护着世界的和平。我们都是战士，守护着自己的家园。fighter 就是我们的称号。或许你从来没有看过我们的这一面，但你绝不能忽略我们的存在。SNH48李宇琪2016年百度贴吧年榜冠军单曲，来自SNH48在2016年3月推出的《正义之手》，这首歌曲按照毛毛李宇琪的特色进行重新混音，让她浑厚的音色和节奏感得以发挥，歌曲里所有和声也都重新编写，并由李宇琪亲自演唱，舞蹈也进行了重新编排，让这首歌有了新的味道。"];
    [DB insertMusicWithID:10003 name:@"SWEET GIRL" icon:@"http://p1.music.126.net/hvwDk3gLPtdz0myJAh_KFg==/109951163091090469.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=525238795.mp3" singer:@"Dom.T / AY楊佬叁" introduce:@"《Sweet Girl》是国风Dom.T个人第二支单曲，流畅的flow，动感复古的节奏，甜蜜的主题，让这首歌充满了独一不二的爱意。这首歌更是国风Dom.T和他的女友AY罾先™共同演唱，真情实感的流露，带给这个冬天最暖的体会。"];
    [DB insertMusicWithID:10004 name:@"爱的就是你" icon:@"http://p1.music.126.net/IHRFjs7UHB3GXTRR1TJzUg==/18801648836944961.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=489768079.mp3" singer:@"苑笙" introduce:@"《爱的就是你》。是歌手刘佳的原创歌曲，收录于《一个人走》的专辑中。他本人囊括了本歌曲的填词、谱曲、编曲、演唱集四项于一身。电影《城市游戏》片尾曲、插曲。"];
    [DB insertMusicWithID:10005 name:@"圣诞结" icon:@"http://p1.music.126.net/NmubkKwQ14jEwU50FIjHIw==/18632324046199358.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=480575219.mp3" singer:@"蔡宜达" introduce:@"《圣诞结》这首歌曲是“进击的女帝”张碧晨在江苏卫视一档节目《蒙面唱将猜猜猜》中演绎的歌曲。用轻柔的女声来演绎这首陈奕迅的经典，情绪和嗓音逐渐上升拉长，收放自如，少了份低沉，多了份落寞，女声版独具特色。住在从不下雪的城市，依旧能感受到刺骨的寒冷。"];
    [DB insertMusicWithID:10006 name:@"秋又来了" icon:@"http://p1.music.126.net/ba20DLSF7xMVZHo7QHkFkQ==/109951163057224950.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=516823195.mp3" singer:@"孟大宝" introduce:@"《秋又来了》是由孟大宝作曲、知错填词，孟大宝和房东的猫演唱的歌曲。“东篱花儿瘦，种花人儿恼 年光容易逝，昨还杏儿小 秋又来了” 这是房东的猫和孟大宝首次合作的，关于写秋天的歌，秋之素装，秋之美妙。 都汇成一句“一世闲云平淡好”。"];
    [DB insertMusicWithID:10007 name:@"重生" icon:@"http://p1.music.126.net/4DMV1vkYiYVlAdICZNnqAA==/109951163081286379.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=522631413.mp3" singer:@"容祖儿" introduce:@"《重生》是电影《解忧杂货店》主题曲，由韩寒作词，王宗贤作曲，容祖儿演唱容祖儿首次演唱内地电影的主题曲，她表示第一次听到《重生》demo的时候，就觉得歌曲有种倾诉的感觉，很适合现在的自己来唱，因为“有所经历才能领悟歌曲中的意思”。这首《重生》在原著中出现过但没有歌词，荣幸的是，此次邀请到了艺术指导韩寒来为歌曲作词，赋予了歌曲新的生命力。监制董韵诗还表示“这首歌在影片中出现多次，也影响了剧中所有的角色”。歌词描述了人生必须要经历的阶段，不必悲观而是充满希望的，希望大家在迷茫时可以从中找到力量，因为“梦想是可以让人重生的”。"];
    [DB insertMusicWithID:10008 name:@"小公主" icon:@"http://p1.music.126.net/EMsVbyEr7EdyYd7jFJQjxA==/109951163084225586.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=523658940.mp3" singer:@"蒋蒋，杨清柠" introduce:@"制作人：Kent王健；    录音师：浔浔/Kent王健  混音：殇小谨    混音/母带工作室：Hot Music Studio   母带：殇小谨    监制：三千  和声编写/和声：Kent王健    企划营销：梦童娱乐  录音室：1803 Music Studio    OP：龙天腾"];
    [DB insertMusicWithID:10009 name:@"爱在日落黄昏时" icon:@"http://p1.music.126.net/4MTubWyjyJW-BzL-M8UoUw==/109951163058904157.jpg" fileName:@"http://music.163.com/song/media/outer/url?id=516655013.mp3" singer:@"阿尔达克Ardak" introduce:@"爱在日落黄昏时》是阿尔达克还在筹备中的新专辑其中的一首，全曲从尼龙吉他开始，伴随着阿尔达克悠远舒缓的歌声展开，不悲不喜淡然内敛的叙述。大雨滂沱后温暖的bossanova元素让本作品不单只是首悲伤的情歌，间奏灵动的长笛伴着弦乐团像是南美的浪漫日落。电吉他醇厚的音色，简短的乐句是这首长线条歌曲中明媚的笑靥。二间奏之中，尼龙吉他solo与弦乐的对话，又将旋律线条交给电吉他，用略带overdrive的音色将全曲推向情绪高点。一切都恰到好处，如日落黄昏时的恬静带着淡淡的感伤。"];
    self.songArray = [DB allMusics];
    
    
//    NSString *str = [[NSBundle mainBundle]pathForResource:@"musicPaper" ofType:@"json"];
//    NSData *data = [[NSData alloc]initWithContentsOfFile:str];
//    
//    NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@,  ---%ld",dataArray, dataArray.count);
//    for (NSDictionary *dic in dataArray) {
//        MusicModel *model = [[MusicModel alloc] init];
//        [model setValuesForKeysWithDictionary:dic];
//        [self.songArray addObject:model];
//    }
    
    [self.songTableView reloadData];
}

// 创建列表
- (void)creatTableView
{
    self.songTableView = [[UITableView alloc]initWithFrame:CGRectMake(Frame_x_0, Frame_y_0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    _songTableView.backgroundColor = [UIColor clearColor];
    _songTableView.delegate = self;
    _songTableView.dataSource = self;
    _songTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.songTableView];
}

// 列表行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songArray.count;
}

// 初始化音乐列表cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:songIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:songIdentifier];
    }
    MusicModel *model = [[MusicModel alloc] init];
    model = [self.songArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"PlayerHeader"]];
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
    [cell.imageView.layer setMasksToBounds:YES];
    cell.textLabel.text = [NSString stringWithFormat:@"%@_%@",  model.name, model.singer];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// 音乐列表cell点击跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AudioPlayerController *audio = [AudioPlayerController audioPlayerController];
    [audio initWithArray:self.songArray index:indexPath.row];
    [self.navigationController pushViewController:audio animated:NO];
}

// 音乐列表行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TableViewRowHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
