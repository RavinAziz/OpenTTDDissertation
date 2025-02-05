// Generated from c:/Users/User/Desktop/Individual_Project/OpenTTD_grammar_definitions.g by ANTLR 4.13.1
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue"})
public class OpenTTD_grammar_definitionsParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.13.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, T__36=37, NEWLINE=38, 
		WS=39;
	public static final int
		RULE_script = 0, RULE_rule = 1, RULE_op = 2, RULE_num = 3, RULE_boolean = 4, 
		RULE_maintain = 5, RULE_upgrade_bus = 6, RULE_remove_unprofitable = 7, 
		RULE_add_bus = 8, RULE_build = 9, RULE_fin_var = 10, RULE_debt = 11, RULE_money = 12, 
		RULE_route_var = 13, RULE_bus = 14;
	private static String[] makeRuleNames() {
		return new String[] {
			"script", "rule", "op", "num", "boolean", "maintain", "upgrade_bus", 
			"remove_unprofitable", "add_bus", "build", "fin_var", "debt", "money", 
			"route_var", "bus"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'='", "'!='", "'<'", "'>'", "'<='", "'>='", "'0.0'", "'0.1'", 
			"'0.2'", "'0.3'", "'0.4'", "'0.5'", "'0.6'", "'0.7'", "'0.8'", "'0.9'", 
			"'1.0'", "'true'", "'false'", "'UpgradeBus()'", "'RemoveUnprofitable()'", 
			"'AddBus()'", "'BuildRoute('", "')'", "'balance_left'", "'profit_loan_ratio'", 
			"'current_funds_loan_ratio'", "'debt_taken'", "'debt('", "', '", "'if ('", 
			"'waiting'", "'profit'", "'last_build'", "'last_paid_loan'", "'youngest_vehicle_age'", 
			"' if ('"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, "NEWLINE", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "OpenTTD_grammar_definitions.g"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public OpenTTD_grammar_definitionsParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ScriptContext extends ParserRuleContext {
		public TerminalNode EOF() { return getToken(OpenTTD_grammar_definitionsParser.EOF, 0); }
		public List<BuildContext> build() {
			return getRuleContexts(BuildContext.class);
		}
		public BuildContext build(int i) {
			return getRuleContext(BuildContext.class,i);
		}
		public List<TerminalNode> NEWLINE() { return getTokens(OpenTTD_grammar_definitionsParser.NEWLINE); }
		public TerminalNode NEWLINE(int i) {
			return getToken(OpenTTD_grammar_definitionsParser.NEWLINE, i);
		}
		public List<RuleContext> rule_() {
			return getRuleContexts(RuleContext.class);
		}
		public RuleContext rule_(int i) {
			return getRuleContext(RuleContext.class,i);
		}
		public ScriptContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_script; }
	}

	public final ScriptContext script() throws RecognitionException {
		ScriptContext _localctx = new ScriptContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_script);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(33); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(30);
				build();
				setState(31);
				match(NEWLINE);
				}
				}
				setState(35); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==T__22 );
			setState(42);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__30 || _la==T__36) {
				{
				{
				setState(37);
				rule_();
				setState(38);
				match(NEWLINE);
				}
				}
				setState(44);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(45);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class RuleContext extends ParserRuleContext {
		public MoneyContext money() {
			return getRuleContext(MoneyContext.class,0);
		}
		public BusContext bus() {
			return getRuleContext(BusContext.class,0);
		}
		public RuleContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_rule; }
	}

	public final RuleContext rule_() throws RecognitionException {
		RuleContext _localctx = new RuleContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_rule);
		try {
			setState(49);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__30:
				enterOuterAlt(_localctx, 1);
				{
				setState(47);
				money();
				}
				break;
			case T__36:
				enterOuterAlt(_localctx, 2);
				{
				setState(48);
				bus();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class OpContext extends ParserRuleContext {
		public OpContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_op; }
	}

	public final OpContext op() throws RecognitionException {
		OpContext _localctx = new OpContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_op);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(51);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & 126L) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class NumContext extends ParserRuleContext {
		public NumContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_num; }
	}

	public final NumContext num() throws RecognitionException {
		NumContext _localctx = new NumContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_num);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(53);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & 262016L) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class BooleanContext extends ParserRuleContext {
		public BooleanContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_boolean; }
	}

	public final BooleanContext boolean_() throws RecognitionException {
		BooleanContext _localctx = new BooleanContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_boolean);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(55);
			_la = _input.LA(1);
			if ( !(_la==T__17 || _la==T__18) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class MaintainContext extends ParserRuleContext {
		public Upgrade_busContext upgrade_bus() {
			return getRuleContext(Upgrade_busContext.class,0);
		}
		public Remove_unprofitableContext remove_unprofitable() {
			return getRuleContext(Remove_unprofitableContext.class,0);
		}
		public Add_busContext add_bus() {
			return getRuleContext(Add_busContext.class,0);
		}
		public MaintainContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_maintain; }
	}

	public final MaintainContext maintain() throws RecognitionException {
		MaintainContext _localctx = new MaintainContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_maintain);
		try {
			setState(60);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__19:
				enterOuterAlt(_localctx, 1);
				{
				setState(57);
				upgrade_bus();
				}
				break;
			case T__20:
				enterOuterAlt(_localctx, 2);
				{
				setState(58);
				remove_unprofitable();
				}
				break;
			case T__21:
				enterOuterAlt(_localctx, 3);
				{
				setState(59);
				add_bus();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Upgrade_busContext extends ParserRuleContext {
		public Upgrade_busContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_upgrade_bus; }
	}

	public final Upgrade_busContext upgrade_bus() throws RecognitionException {
		Upgrade_busContext _localctx = new Upgrade_busContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_upgrade_bus);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(62);
			match(T__19);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Remove_unprofitableContext extends ParserRuleContext {
		public Remove_unprofitableContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_remove_unprofitable; }
	}

	public final Remove_unprofitableContext remove_unprofitable() throws RecognitionException {
		Remove_unprofitableContext _localctx = new Remove_unprofitableContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_remove_unprofitable);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(64);
			match(T__20);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Add_busContext extends ParserRuleContext {
		public Add_busContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_add_bus; }
	}

	public final Add_busContext add_bus() throws RecognitionException {
		Add_busContext _localctx = new Add_busContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_add_bus);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(66);
			match(T__21);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class BuildContext extends ParserRuleContext {
		public NumContext num() {
			return getRuleContext(NumContext.class,0);
		}
		public BuildContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_build; }
	}

	public final BuildContext build() throws RecognitionException {
		BuildContext _localctx = new BuildContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_build);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(68);
			match(T__22);
			setState(69);
			num();
			setState(70);
			match(T__23);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Fin_varContext extends ParserRuleContext {
		public Fin_varContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fin_var; }
	}

	public final Fin_varContext fin_var() throws RecognitionException {
		Fin_varContext _localctx = new Fin_varContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_fin_var);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(72);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & 503316480L) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class DebtContext extends ParserRuleContext {
		public BooleanContext boolean_() {
			return getRuleContext(BooleanContext.class,0);
		}
		public NumContext num() {
			return getRuleContext(NumContext.class,0);
		}
		public DebtContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_debt; }
	}

	public final DebtContext debt() throws RecognitionException {
		DebtContext _localctx = new DebtContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_debt);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(74);
			match(T__28);
			setState(75);
			boolean_();
			setState(76);
			match(T__29);
			setState(77);
			num();
			setState(78);
			match(T__23);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class MoneyContext extends ParserRuleContext {
		public Fin_varContext fin_var() {
			return getRuleContext(Fin_varContext.class,0);
		}
		public OpContext op() {
			return getRuleContext(OpContext.class,0);
		}
		public NumContext num() {
			return getRuleContext(NumContext.class,0);
		}
		public DebtContext debt() {
			return getRuleContext(DebtContext.class,0);
		}
		public MoneyContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_money; }
	}

	public final MoneyContext money() throws RecognitionException {
		MoneyContext _localctx = new MoneyContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_money);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(80);
			match(T__30);
			setState(81);
			fin_var();
			setState(82);
			op();
			setState(83);
			num();
			setState(84);
			match(T__23);
			setState(85);
			debt();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Route_varContext extends ParserRuleContext {
		public Route_varContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_route_var; }
	}

	public final Route_varContext route_var() throws RecognitionException {
		Route_varContext _localctx = new Route_varContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_route_var);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(87);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & 133143986176L) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class BusContext extends ParserRuleContext {
		public Route_varContext route_var() {
			return getRuleContext(Route_varContext.class,0);
		}
		public OpContext op() {
			return getRuleContext(OpContext.class,0);
		}
		public NumContext num() {
			return getRuleContext(NumContext.class,0);
		}
		public MaintainContext maintain() {
			return getRuleContext(MaintainContext.class,0);
		}
		public BusContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bus; }
	}

	public final BusContext bus() throws RecognitionException {
		BusContext _localctx = new BusContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_bus);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(89);
			match(T__36);
			setState(90);
			route_var();
			setState(91);
			op();
			setState(92);
			num();
			setState(93);
			match(T__23);
			setState(94);
			maintain();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\u0004\u0001\'a\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004\u0002"+
		"\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007\u0002"+
		"\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b\u0007\u000b\u0002"+
		"\f\u0007\f\u0002\r\u0007\r\u0002\u000e\u0007\u000e\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0004\u0000\"\b\u0000\u000b\u0000\f\u0000#\u0001\u0000\u0001"+
		"\u0000\u0001\u0000\u0005\u0000)\b\u0000\n\u0000\f\u0000,\t\u0000\u0001"+
		"\u0000\u0001\u0000\u0001\u0001\u0001\u0001\u0003\u00012\b\u0001\u0001"+
		"\u0002\u0001\u0002\u0001\u0003\u0001\u0003\u0001\u0004\u0001\u0004\u0001"+
		"\u0005\u0001\u0005\u0001\u0005\u0003\u0005=\b\u0005\u0001\u0006\u0001"+
		"\u0006\u0001\u0007\u0001\u0007\u0001\b\u0001\b\u0001\t\u0001\t\u0001\t"+
		"\u0001\t\u0001\n\u0001\n\u0001\u000b\u0001\u000b\u0001\u000b\u0001\u000b"+
		"\u0001\u000b\u0001\u000b\u0001\f\u0001\f\u0001\f\u0001\f\u0001\f\u0001"+
		"\f\u0001\f\u0001\r\u0001\r\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e"+
		"\u0001\u000e\u0001\u000e\u0001\u000e\u0001\u000e\u0000\u0000\u000f\u0000"+
		"\u0002\u0004\u0006\b\n\f\u000e\u0010\u0012\u0014\u0016\u0018\u001a\u001c"+
		"\u0000\u0005\u0001\u0000\u0001\u0006\u0001\u0000\u0007\u0011\u0001\u0000"+
		"\u0012\u0013\u0001\u0000\u0019\u001c\u0001\u0000 $V\u0000!\u0001\u0000"+
		"\u0000\u0000\u00021\u0001\u0000\u0000\u0000\u00043\u0001\u0000\u0000\u0000"+
		"\u00065\u0001\u0000\u0000\u0000\b7\u0001\u0000\u0000\u0000\n<\u0001\u0000"+
		"\u0000\u0000\f>\u0001\u0000\u0000\u0000\u000e@\u0001\u0000\u0000\u0000"+
		"\u0010B\u0001\u0000\u0000\u0000\u0012D\u0001\u0000\u0000\u0000\u0014H"+
		"\u0001\u0000\u0000\u0000\u0016J\u0001\u0000\u0000\u0000\u0018P\u0001\u0000"+
		"\u0000\u0000\u001aW\u0001\u0000\u0000\u0000\u001cY\u0001\u0000\u0000\u0000"+
		"\u001e\u001f\u0003\u0012\t\u0000\u001f \u0005&\u0000\u0000 \"\u0001\u0000"+
		"\u0000\u0000!\u001e\u0001\u0000\u0000\u0000\"#\u0001\u0000\u0000\u0000"+
		"#!\u0001\u0000\u0000\u0000#$\u0001\u0000\u0000\u0000$*\u0001\u0000\u0000"+
		"\u0000%&\u0003\u0002\u0001\u0000&\'\u0005&\u0000\u0000\')\u0001\u0000"+
		"\u0000\u0000(%\u0001\u0000\u0000\u0000),\u0001\u0000\u0000\u0000*(\u0001"+
		"\u0000\u0000\u0000*+\u0001\u0000\u0000\u0000+-\u0001\u0000\u0000\u0000"+
		",*\u0001\u0000\u0000\u0000-.\u0005\u0000\u0000\u0001.\u0001\u0001\u0000"+
		"\u0000\u0000/2\u0003\u0018\f\u000002\u0003\u001c\u000e\u00001/\u0001\u0000"+
		"\u0000\u000010\u0001\u0000\u0000\u00002\u0003\u0001\u0000\u0000\u0000"+
		"34\u0007\u0000\u0000\u00004\u0005\u0001\u0000\u0000\u000056\u0007\u0001"+
		"\u0000\u00006\u0007\u0001\u0000\u0000\u000078\u0007\u0002\u0000\u0000"+
		"8\t\u0001\u0000\u0000\u00009=\u0003\f\u0006\u0000:=\u0003\u000e\u0007"+
		"\u0000;=\u0003\u0010\b\u0000<9\u0001\u0000\u0000\u0000<:\u0001\u0000\u0000"+
		"\u0000<;\u0001\u0000\u0000\u0000=\u000b\u0001\u0000\u0000\u0000>?\u0005"+
		"\u0014\u0000\u0000?\r\u0001\u0000\u0000\u0000@A\u0005\u0015\u0000\u0000"+
		"A\u000f\u0001\u0000\u0000\u0000BC\u0005\u0016\u0000\u0000C\u0011\u0001"+
		"\u0000\u0000\u0000DE\u0005\u0017\u0000\u0000EF\u0003\u0006\u0003\u0000"+
		"FG\u0005\u0018\u0000\u0000G\u0013\u0001\u0000\u0000\u0000HI\u0007\u0003"+
		"\u0000\u0000I\u0015\u0001\u0000\u0000\u0000JK\u0005\u001d\u0000\u0000"+
		"KL\u0003\b\u0004\u0000LM\u0005\u001e\u0000\u0000MN\u0003\u0006\u0003\u0000"+
		"NO\u0005\u0018\u0000\u0000O\u0017\u0001\u0000\u0000\u0000PQ\u0005\u001f"+
		"\u0000\u0000QR\u0003\u0014\n\u0000RS\u0003\u0004\u0002\u0000ST\u0003\u0006"+
		"\u0003\u0000TU\u0005\u0018\u0000\u0000UV\u0003\u0016\u000b\u0000V\u0019"+
		"\u0001\u0000\u0000\u0000WX\u0007\u0004\u0000\u0000X\u001b\u0001\u0000"+
		"\u0000\u0000YZ\u0005%\u0000\u0000Z[\u0003\u001a\r\u0000[\\\u0003\u0004"+
		"\u0002\u0000\\]\u0003\u0006\u0003\u0000]^\u0005\u0018\u0000\u0000^_\u0003"+
		"\n\u0005\u0000_\u001d\u0001\u0000\u0000\u0000\u0004#*1<";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}