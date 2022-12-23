package funkin.macros;

/**
 * Simple macro class that holds macros for the game's build info.
 * @author Leather128
 */
class BuildInfoMacros {
	public static macro function get_build_number():haxe.macro.Expr.ExprOf<Int> {
		#if (!display && debug)
		var build_number:Int = Std.parseInt(sys.io.File.getContent(sys.FileSystem.fullPath('build.txt'))) + 1;
		sys.io.File.saveContent(sys.FileSystem.fullPath('build.txt'), Std.string(build_number));

		return macro $v{build_number};
		#else
		return macro $v{-1};
		#end
	}

    public static macro function get_build_commit_id():haxe.macro.Expr.ExprOf<String> {
		#if (!display && debug)
        var git_process:sys.io.Process = new sys.io.Process('git', ['log', '--format=%h', '-n', '1']);
        if (git_process.exitCode() != 0) return macro $v{'n/a'};
        
		return macro $v{git_process.stdout.readLine().trim()};
		#else
		return macro $v{'n/a'};
		#end
	}
}
