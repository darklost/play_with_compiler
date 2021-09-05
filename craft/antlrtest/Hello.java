// Generated from .\antlrtest\Hello.g4 by ANTLR 4.9.2

package antlrtest;

import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class Hello extends Lexer {
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		If=1, Int=2, IntLiteral=3, StringLiteral=4, AssignmentOP=5, RelationalOP=6, 
		Star=7, Plus=8, Sharp=9, SemiColon=10, Dot=11, Comm=12, LeftBracket=13, 
		RightBracket=14, LeftBrace=15, RightBrace=16, LeftParen=17, RightParen=18, 
		Id=19, Whitespace=20, Newline=21;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"If", "Int", "IntLiteral", "StringLiteral", "AssignmentOP", "RelationalOP", 
			"Star", "Plus", "Sharp", "SemiColon", "Dot", "Comm", "LeftBracket", "RightBracket", 
			"LeftBrace", "RightBrace", "LeftParen", "RightParen", "Id", "Whitespace", 
			"Newline"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, "'int'", null, null, "'='", null, "'*'", "'+'", "'#'", "';'", 
			"'.'", "','", "'['", "']'", "'{'", "'}'", "'('", "')'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "If", "Int", "IntLiteral", "StringLiteral", "AssignmentOP", "RelationalOP", 
			"Star", "Plus", "Sharp", "SemiColon", "Dot", "Comm", "LeftBracket", "RightBracket", 
			"LeftBrace", "RightBrace", "LeftParen", "RightParen", "Id", "Whitespace", 
			"Newline"
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


	public Hello(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Hello.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\27\u0081\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\3\2\3\2\3\2\3\2\3\2\5\2"+
		"\63\n\2\3\3\3\3\3\3\3\3\3\4\6\4:\n\4\r\4\16\4;\3\5\3\5\7\5@\n\5\f\5\16"+
		"\5C\13\5\3\5\3\5\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7Q\n\7\3\b"+
		"\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3\20"+
		"\3\20\3\21\3\21\3\22\3\22\3\23\3\23\3\24\3\24\7\24m\n\24\f\24\16\24p\13"+
		"\24\3\25\6\25s\n\25\r\25\16\25t\3\25\3\25\3\26\3\26\5\26{\n\26\3\26\5"+
		"\26~\n\26\3\26\3\26\3A\2\27\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25"+
		"\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27\3\2\6\3\2\62"+
		";\5\2C\\aac|\6\2\62;C\\aac|\4\2\13\13\"\"\2\u008b\2\3\3\2\2\2\2\5\3\2"+
		"\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21"+
		"\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2"+
		"\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3"+
		"\2\2\2\2)\3\2\2\2\2+\3\2\2\2\3\62\3\2\2\2\5\64\3\2\2\2\79\3\2\2\2\t=\3"+
		"\2\2\2\13F\3\2\2\2\rP\3\2\2\2\17R\3\2\2\2\21T\3\2\2\2\23V\3\2\2\2\25X"+
		"\3\2\2\2\27Z\3\2\2\2\31\\\3\2\2\2\33^\3\2\2\2\35`\3\2\2\2\37b\3\2\2\2"+
		"!d\3\2\2\2#f\3\2\2\2%h\3\2\2\2\'j\3\2\2\2)r\3\2\2\2+}\3\2\2\2-.\7k\2\2"+
		".\63\7h\2\2/\60\7\u6fe3\2\2\60\61\7\u509d\2\2\61\63\7\u704b\2\2\62-\3"+
		"\2\2\2\62/\3\2\2\2\63\4\3\2\2\2\64\65\7k\2\2\65\66\7p\2\2\66\67\7v\2\2"+
		"\67\6\3\2\2\28:\t\2\2\298\3\2\2\2:;\3\2\2\2;9\3\2\2\2;<\3\2\2\2<\b\3\2"+
		"\2\2=A\7$\2\2>@\13\2\2\2?>\3\2\2\2@C\3\2\2\2AB\3\2\2\2A?\3\2\2\2BD\3\2"+
		"\2\2CA\3\2\2\2DE\7$\2\2E\n\3\2\2\2FG\7?\2\2G\f\3\2\2\2HI\7?\2\2IQ\7?\2"+
		"\2JQ\7@\2\2KL\7@\2\2LQ\7?\2\2MQ\7>\2\2NO\7>\2\2OQ\7?\2\2PH\3\2\2\2PJ\3"+
		"\2\2\2PK\3\2\2\2PM\3\2\2\2PN\3\2\2\2Q\16\3\2\2\2RS\7,\2\2S\20\3\2\2\2"+
		"TU\7-\2\2U\22\3\2\2\2VW\7%\2\2W\24\3\2\2\2XY\7=\2\2Y\26\3\2\2\2Z[\7\60"+
		"\2\2[\30\3\2\2\2\\]\7.\2\2]\32\3\2\2\2^_\7]\2\2_\34\3\2\2\2`a\7_\2\2a"+
		"\36\3\2\2\2bc\7}\2\2c \3\2\2\2de\7\177\2\2e\"\3\2\2\2fg\7*\2\2g$\3\2\2"+
		"\2hi\7+\2\2i&\3\2\2\2jn\t\3\2\2km\t\4\2\2lk\3\2\2\2mp\3\2\2\2nl\3\2\2"+
		"\2no\3\2\2\2o(\3\2\2\2pn\3\2\2\2qs\t\5\2\2rq\3\2\2\2st\3\2\2\2tr\3\2\2"+
		"\2tu\3\2\2\2uv\3\2\2\2vw\b\25\2\2w*\3\2\2\2xz\7\17\2\2y{\7\f\2\2zy\3\2"+
		"\2\2z{\3\2\2\2{~\3\2\2\2|~\7\f\2\2}x\3\2\2\2}|\3\2\2\2~\177\3\2\2\2\177"+
		"\u0080\b\26\2\2\u0080,\3\2\2\2\f\2\62;APlntz}\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}