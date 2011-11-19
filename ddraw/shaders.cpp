// DXGL
// Copyright (C) 2011 William Feely

// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.

// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

#include "common.h"
#include "shaders.h"

char frag_Pal256[] =  "\
#version 110\n\
uniform sampler2D ColorTable; \n\
uniform sampler2D IndexTexture; \n\
void main() \n\
{ \n\
	vec4 myindex = texture2D(IndexTexture, gl_TexCoord[0].xy); \n\
	vec4 texel = texture2D(ColorTable, myindex.xy); \n\
	gl_FragColor = texel; \n\
} ";

char frag_ColorKey[] = "\
#version 110\n\
uniform sampler2D myTexture;\n\
uniform ivec4 keyIn;\n\
void main (void)\n\
{\n\
 vec4 value = texture2D(myTexture, vec2(gl_TexCoord[0]));\n\
 ivec4 comp = ivec4(texture2D(myTexture, vec2(gl_TexCoord[0]))*255.0);\n\
 if (comp == keyIn)\n\
  discard;\n\
 gl_FragColor = value;\n\
} ";

char frag_ColorKeyMask[] = "\
#version 110\n\
uniform sampler2D myTexture;\n\
uniform ivec4 keyIn;\n\
void main (void)\n\
{\n\
 vec4 value = texture2D(myTexture, vec2(gl_TexCoord[0]));\n\
 ivec4 comp = ivec4(texture2D(myTexture, vec2(gl_TexCoord[0]))*255.0);\n\
 if (comp == keyIn)\n\
  gl_FragColor[0] = 1.0;\n\
 else gl_FragColor[0] = 0.0;\n\
} ";

char frag_2ColorKey[] = "\
#version 110\n\
uniform sampler2D myTexture;\n\
uniform sampler2D maskTexture;\n\
uniform ivec4 keyIn;\n\
void main (void)\n\
{\n\
 vec4 value = texture2D(myTexture, vec2(gl_TexCoord[0]));\n\
 ivec4 comp = ivec4(texture2D(myTexture, vec2(gl_TexCoord[0]))*255.0);\n\
 if (comp == keyIn)\n\
  discard;\n\
 ivec4 comp2 = ivec4(texture2D(maskTexture,vec2(gl_TexCoord[1]))*255.0);\n\
 if(comp2[0] == 0)\n\
  discard;\n\
 gl_FragColor = value;\n\
} ";

int NumberOfShaders = 4;

SHADER shaders[] = {
	{0,0,	NULL,			frag_Pal256,		0},
	{0,0,	NULL,			frag_ColorKey,		0},
	{0,0,	NULL,			frag_ColorKeyMask,	0},
	{0,0,	NULL,			frag_2ColorKey,		0}
};

void CompileShaders()
{
	const GLchar *src;
	GLint srclen;
	for(int i = 0; i < NumberOfShaders; i++)
	{
		shaders[i].prog = glCreateProgram();
		if(shaders[i].vsrc)
		{
			shaders[i].vs = glCreateShader(GL_VERTEX_SHADER);
			src = shaders[i].vsrc;
			srclen = strlen(shaders[i].vsrc);
			glShaderSource(shaders[i].vs,1,&src,&srclen);
			glCompileShader(shaders[i].vs);
			glAttachShader(shaders[i].prog,shaders[i].vs);
		}
		if(shaders[i].fsrc)
		{
			shaders[i].fs = glCreateShader(GL_FRAGMENT_SHADER);
			src = shaders[i].fsrc;
			srclen = strlen(shaders[i].fsrc);
			glShaderSource(shaders[i].fs,1,&src,&srclen);
			glCompileShader(shaders[i].fs);
			glAttachShader(shaders[i].prog,shaders[i].fs);
		}
		glLinkProgram(shaders[i].prog);
	}
}
